//
//  PreviewControlView.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Foundation
import Kingfisher
import UIKit

public class PreviewControlView: UIView {
    
    private let stackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    private let contentSliderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let sliderView: UISlider = {
        let view = UISlider()
        view.value = 0
        view.maximumValue = 100
        view.minimumValue = 0
        view.thumbTintColor = .white
        view.minimumTrackTintColor = .white
        view.isContinuous = false
        return view
    }()
    
    private let currentTimeLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.text = "0:00"
        return view
    }()
    
    private let durationTimeLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.text = "0:00"
        return view
    }()
    
    private let contentButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let stateButtonView: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        view.tintColor = .white
        view.contentVerticalAlignment = .fill
        view.contentHorizontalAlignment = .fill
        return view
    }()
    
    var currentTime: String? {
        didSet {
            currentTimeLabel.text = currentTime ?? "0:00"
        }
    }
    
    var durationTime: Double? {
        didSet {
            durationTimeLabel.text = durationTime?.formatToTime() ?? "0:00"
            sliderView.maximumValue = Float(durationTime ?? 0)
        }
    }
    
    var isPlaying: Bool? {
        didSet {
            updateStateButton()
        }
    }
    
    var sliderValueChange: ((Double) -> Void)?
    var handleStateButton: (() -> Void)?
    
    var isEnableUpdateSliderView: Bool = true
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateCurrentTime(seconds: Double) {
        currentTime = seconds.formatToTime()
        updateSlider(seconds: seconds)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        self.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(contentSliderView)
        stackViewContainer.addArrangedSubview(contentButtonView)
        contentSliderView.addSubview(sliderView)
        contentSliderView.addSubview(currentTimeLabel)
        contentSliderView.addSubview(durationTimeLabel)
        contentButtonView.addSubview(stateButtonView)
        self.updateUIConstraints()
        
        sliderView.addTarget(self, action: #selector(sliderValueChange(_:)), for: .valueChanged)
        stateButtonView.addTarget(self, action: #selector(handleStateButton(_:)), for: .touchUpInside)
    }
    
    private func updateUIConstraints() {
        self.stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.stackViewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        self.stackViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.stackViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.stackViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        self.sliderView.translatesAutoresizingMaskIntoConstraints = false
        self.sliderView.topAnchor.constraint(equalTo: contentSliderView.topAnchor).isActive = true
        self.sliderView.leadingAnchor.constraint(equalTo: contentSliderView.leadingAnchor).isActive = true
        self.sliderView.trailingAnchor.constraint(equalTo: contentSliderView.trailingAnchor).isActive = true
        
        self.currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currentTimeLabel.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 5).isActive = true
        self.currentTimeLabel.leadingAnchor.constraint(equalTo: contentSliderView.leadingAnchor).isActive = true
        self.currentTimeLabel.bottomAnchor.constraint(equalTo: contentSliderView.bottomAnchor).isActive = true
        
        self.durationTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.durationTimeLabel.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 5).isActive = true
        self.durationTimeLabel.trailingAnchor.constraint(equalTo: contentSliderView.trailingAnchor).isActive = true
        self.durationTimeLabel.bottomAnchor.constraint(equalTo: contentSliderView.bottomAnchor).isActive = true
        
        self.stateButtonView.translatesAutoresizingMaskIntoConstraints = false
        self.stateButtonView.topAnchor.constraint(equalTo: contentButtonView.topAnchor).isActive = true
        self.stateButtonView.bottomAnchor.constraint(equalTo: contentButtonView.bottomAnchor).isActive = true
        self.stateButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.stateButtonView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.stateButtonView.centerXAnchor.constraint(equalTo: contentButtonView.centerXAnchor).isActive = true
    }
    
    private func updateSlider(seconds: Double) {
        let sliderValue = seconds
        if !sliderView.isTracking, isEnableUpdateSliderView {
            sliderView.value = Float(sliderValue)
        }
    }
    
    private func updateStateButton() {
        if isPlaying == true {
            stateButtonView.setImage(UIImage(systemName: "pause.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            stateButtonView.setImage(UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc func sliderValueChange(_ sender: UISlider) {
        isEnableUpdateSliderView = false
        self.sliderValueChange?(Double(sender.value))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isEnableUpdateSliderView = true
        }
    }
    
    @objc func handleStateButton(_ sender: UIButton) {
        self.handleStateButton?()
    }
}
