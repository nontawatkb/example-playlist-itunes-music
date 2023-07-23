//
//  PreviewViewModel.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 19/7/2566 BE.
//

import Combine
import Foundation
import UIKit

protocol PreviewProtocolInput {
    func downloadPreviewUrl()
}

protocol PreviewProtocolOutput: AnyObject {
    var didUpdateLoadingView: ((Bool) -> Void)? { get set }
    var didUpdateAVPlayer: (() -> Void)? { get set }
    
    var previewURL: URL? { get }
    var previewItem: SearchItem? { get }
}

protocol PreviewProtocol {
    var input: PreviewProtocolInput { get }
    var output: PreviewProtocolOutput { get }
}

class PreviewViewModel: NSObject, PreviewProtocol {
    
    var input: PreviewProtocolInput { return self }
    var output: PreviewProtocolOutput { return self }
    
    // MARK: - UseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private let searchItem: SearchItem?
    private var urlPreview: URL?
    
    init(searchItem: SearchItem?) {
        self.searchItem = searchItem
    }
    
    deinit {
        debugPrint("🔅 Deinitialized. \(String(describing: self))")
    }
    
    // MARK: - Data-binding OutPut
    var didUpdateLoadingView: ((Bool) -> Void)?
    var didUpdateAVPlayer: (() -> Void)?

}

// MARK: - Input
extension PreviewViewModel: PreviewProtocolInput {
    
    func downloadPreviewUrl() {
        self.urlPreview = nil
        guard let previewUrl = self.searchItem?.previewUrl, let url = URL(string: previewUrl) else { return }
        self.didUpdateLoadingView?(true)
        if let destinationURL = filterURLFromCachesDirectory(url: url) {
            self.urlPreview = destinationURL
            self.didUpdateLoadingView?(false)
            self.didUpdateAVPlayer?()
        } else {
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
            let downloadTask = urlSession.downloadTask(with: URLRequest(url: url))
            downloadTask.resume()
        }
    }
    
    private func filterURLFromCachesDirectory(url: URL) -> URL? {
        let pathDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let contentsOfDirectory = try? FileManager.default.contentsOfDirectory(atPath: pathDirectory[0])
        guard let lastPathUrl = url.pathComponents.last,
              !pathDirectory.isEmpty,
              let matchContents = contentsOfDirectory?.contains(where: { $0 == lastPathUrl}),
              matchContents else { return nil }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let matchContentsURL = documentsPath.appendingPathComponent(lastPathUrl)
        return matchContentsURL
    }
    
}

// MARK: - OutPut
extension PreviewViewModel: PreviewProtocolOutput {
    var previewItem: SearchItem? {
        return searchItem
    }
    
    var previewURL: URL? {
        return urlPreview
    }
}


// MARK: - URLSessionDownloadDelegate
extension PreviewViewModel: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.urlPreview = destinationURL
            self.didUpdateLoadingView?(false)
            self.didUpdateAVPlayer?()
        } catch {
            debugPrint("Copy Error \(error.localizedDescription)")
        }
        session.finishTasksAndInvalidate()
    }

}
