//
//  PreviewController.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 19/7/2566 BE.
//

import UIKit
import AVFAudio
import AVFoundation

class PreviewController: UIViewController {
    
    private let viewModel: PreviewViewModel = PreviewViewModel()
    
    var avPlayer : AVPlayer?
    private var previewItem: SearchItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        print("PreviewController")
        downloadFileFromURL()
    }
    
    func configure(previewItem: SearchItem?) {
        self.previewItem = previewItem
    }

    func downloadFileFromURL() {
        guard let previewUrl = self.previewItem?.previewUrl, let url = URL(string: previewUrl) else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let downloadTask = urlSession.downloadTask(with: URLRequest(url: url))
        downloadTask.resume()
    }
    
    func play(url: URL) {
        print("playing \(url)")

        do {

            let playerItem = AVPlayerItem(url: url)
            self.avPlayer = try AVPlayer(playerItem: playerItem)
            avPlayer!.volume = 1.0
            avPlayer!.play()
        } catch let error as NSError {
            self.avPlayer = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        let content = try? FileManager.default.contentsOfDirectory(atPath: path)
        debugPrint("count \(content?.count)")
    }
    
}

extension PreviewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        
        try? FileManager.default.removeItem(at: destinationURL)
        
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            debugPrint("didFinishDownloadingTo \(destinationURL)")
            self.play(url: destinationURL)
        } catch {
            debugPrint("Copy Error \(error.localizedDescription)")
        }
        session.finishTasksAndInvalidate()
    }
}
