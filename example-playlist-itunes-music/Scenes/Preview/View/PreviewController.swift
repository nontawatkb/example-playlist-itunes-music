//
//  PreviewController.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 19/7/2566 BE.
//

import UIKit
import AVFAudio
import AVFoundation
import SwiftUI

class PreviewController: UIViewController {
    
    private(set) var viewModel: PreviewViewModel!
    private let spinnerView = SpinnerViewController()
    private var avPlayer: AVPlayer?
    private var isMediaPlaybackDidEnd: Bool = false
    
    private let bgContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let stackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    private let previewPosterView: PreviewPosterView = {
        let view = PreviewPosterView()
        return view
    }()
    
    private let previewDetailView: PreviewDetailView = {
        let view = PreviewDetailView()
        return view
    }()
    
    private let previewControlView: PreviewControlView = {
        let view = PreviewControlView()
        return view
    }()
    
    // MARK: - Player Observer
    private(set) var timeObserverToken: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.input.downloadPreviewUrl()
    }
    
    deinit {
        debugPrint("🔅 Deinitialized. \(String(describing: self))")
        removeMediaPlayerObservers()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateUIConstraints()
    }
    
    func configure(searchItem: SearchItem?) {
        viewModel = PreviewViewModel(searchItem: searchItem)
        bindToViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(bgContainerView)
        bgContainerView.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(previewPosterView)
        stackViewContainer.addArrangedSubview(previewDetailView)
        stackViewContainer.addArrangedSubview(previewControlView)
        updateUIConstraints()
        updateDetail()
    }
    
    private func updateUIConstraints() {
        let guide = view.safeAreaLayoutGuide
        bgContainerView.translatesAutoresizingMaskIntoConstraints = false
        bgContainerView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        bgContainerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        bgContainerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        bgContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        stackViewContainer.topAnchor.constraint(equalTo: bgContainerView.topAnchor).isActive = true
        stackViewContainer.leadingAnchor.constraint(equalTo: bgContainerView.leadingAnchor).isActive = true
        stackViewContainer.trailingAnchor.constraint(equalTo: bgContainerView.trailingAnchor).isActive = true
        stackViewContainer.bottomAnchor.constraint(equalTo: bgContainerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func updateDetail() {
        guard let previewItem = viewModel.output.previewItem else { return }
        previewPosterView.imageURL = previewItem.artworkUrl100
        previewDetailView.trackName = previewItem.trackName
        previewDetailView.artistName = previewItem.artistName
    }
    
    private func updateAVPlayer() {
        guard let urlPreview = viewModel.output.previewURL else { return }
        let playerItem = AVPlayerItem(url: urlPreview)
        avPlayer = AVPlayer(playerItem: playerItem)
        addPeriodicTimeObserver()
        avPlayer?.volume = 1.0
        avPlayer?.play()
        updateDuration()
        updateControlPlaying()
    }
    
    private func updateDuration() {
        Task.init {
            do {
                let duration = try await avPlayer?.currentItem?.asset.load(.duration)
                let seconds = duration?.seconds
                previewControlView.durationTime = seconds
            } catch {
                print("Fetching images failed with error \(error)")
            }
        }
    }
    
    func addPeriodicTimeObserver() {
        removeMediaPlayerObservers()
        let interval = CMTime(seconds: 1.0,
                                  preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = avPlayer?.addPeriodicTimeObserver(forInterval: interval,
                                                           queue: nil) { [weak self] time in
            guard let self = self else { return }
            self.onTimeDidChange(time: time)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleMediaPlaybackEnded),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    func removeMediaPlayerObservers() {
        if let mediaTimeObserverToRemove = timeObserverToken {
            avPlayer?.removeTimeObserver(mediaTimeObserverToRemove)
            timeObserverToken = nil
        }
        if avPlayer?.currentItem != nil {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                      object: avPlayer?.currentItem)
        }
    }
    @objc func handleMediaPlaybackEnded() {
        isMediaPlaybackDidEnd = true
        previewControlView.isPlaying = avPlayer?.isPlaying
    }
    
    func onTimeDidChange(time: CMTime) {
        isMediaPlaybackDidEnd = false
        previewControlView.updateCurrentTime(seconds: time.seconds)
    }
    
    private func updateControlPlaying() {
        previewControlView.isPlaying = avPlayer?.isPlaying
    }
}

// MARK: - Binding
extension PreviewController {
    
    func bindToViewModel() {
        viewModel.output.didUpdateLoadingView = didUpdateLoadingView()
        viewModel.output.didUpdateAVPlayer = didUpdateAVPlayer()
        previewPosterView.onChangeBackgroundColor = onChangeBackgroundColor()
        previewControlView.sliderValueChange =  sliderValueChange()
        previewControlView.handleStateButton = handleStateButton()
    }
    
    func didUpdateLoadingView() -> ((Bool) -> Void) {
        return { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.startLoadingView(spinnerView: spinnerView)
            } else {
                self.stopLoadingView(spinnerView: spinnerView)
            }
        }
    }
    
    func didUpdateAVPlayer() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            self.updateAVPlayer()
        }
    }
    
    func onChangeBackgroundColor() -> ((UIColor?) -> Void) {
        return { [weak self] color in
            guard let self = self else { return }
            bgContainerView.backgroundColor = color?.withAlphaComponent(0.5) ?? .black
        }
    }
    
    func sliderValueChange() -> ((Double) -> Void) {
        return { [weak self] seekDuration in
            guard let self = self else { return }
            let time = CMTime(seconds: seekDuration, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            self.avPlayer?.seek(to: time)
        }
    }
    
    func handleStateButton() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            if self.avPlayer?.isPlaying == true {
                self.avPlayer?.pause()
                self.updateControlPlaying()
            } else {
                if isMediaPlaybackDidEnd {
                    self.avPlayer?.seek(to: CMTime.zero)
                }
                self.avPlayer?.play()
                self.updateControlPlaying()
            }
        }
    }
}
