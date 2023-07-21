//
//  SearchViewModel.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 19/7/2566 BE.
//

import Combine
import Foundation
import UIKit

protocol SearchProtocolInput {
    func getSearch(text: String?)
    
    func didSelectItemAt(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

protocol SearchProtocolOutput: AnyObject {
    
    var didUpdateTableView: (() -> Void)? { get set }
    var didUpdateLoadingView: ((Bool) -> Void)? { get set }
    
    func getCountSearchResults() -> Int
    
    func getNumberOfRowsInSection(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func getCellForRowAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func getSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

protocol SearchProtocol {
    var input: SearchProtocolInput { get }
    var output: SearchProtocolOutput { get }
}

class SearchViewModel: SearchProtocol {
    
    var input: SearchProtocolInput { return self }
    var output: SearchProtocolOutput { return self }
    
    // MARK: - UseCase
    private let getSearchUseCase: GetSearchUseCase
    private var anyCancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Properties
    private var listSearchResults: [SearchItem] = []
    let viewController: UIViewController

    init(viewController: UIViewController,
         getSearchUseCase: GetSearchUseCase = GetSearchUseCaseImpl()) {
        self.viewController = viewController
        self.getSearchUseCase = getSearchUseCase
        clearCache()
    }
    
    deinit {
        debugPrint("🔅 Deinitialized. \(String(describing: self))")
    }
    
    // MARK: - Data-binding OutPut
    var didUpdateTableView: (() -> Void)?
    var didUpdateLoadingView: ((Bool) -> Void)?
    
    private func clearCache() {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        let content = try? FileManager.default.contentsOfDirectory(atPath: path)
        debugPrint("count \(content?.count)")
        try? FileManager.default.removeItem(atPath: path)
        
        let contentNew = try? FileManager.default.contentsOfDirectory(atPath: path)
        debugPrint("contentNew \(contentNew?.count)")
    }
    
}

// MARK: - Input
extension SearchViewModel: SearchProtocolInput {
    func getSearch(text: String?) {
        guard let term = text else { return }
        self.didUpdateLoadingView?(true)
        self.getSearchUseCase.execute(term: term)
            .sink(receiveCompletion: { _ in
                self.didUpdateLoadingView?(false)
                self.didUpdateTableView?()
            }, receiveValue: { response in
                self.listSearchResults = response?.results ?? []
            })
            .store(in: &anyCancellable)
    }
    
    func didSelectItemAt(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previewController = PreviewController()
        previewController.configure(previewItem: self.listSearchResults[indexPath.row])
        viewController.present(previewController, animated: true)
        
    }
}

// MARK: - OutPut
extension SearchViewModel: SearchProtocolOutput {
    func getNumberOfRowsInSection(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listSearchResults.count
    }
    
    func getCellForRowAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistItemCollectionViewCell.identifier, for: indexPath) as! PlaylistItemCollectionViewCell
        cell.data = listSearchResults[indexPath.row]
        return cell
    }
    
    func getSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var countPerWith = 2
        if UIDevice.current.orientation.isLandscape || UIDevice.current.orientation.isFlat {
            countPerWith = 3
        }
        let cgCountPerWith = CGFloat(countPerWith)
        let removeWidth = ((cgCountPerWith - 1.0) * 8.0) / cgCountPerWith
        let width = ((collectionView.frame.width - 16.0) / cgCountPerWith) - removeWidth
        return CGSize(width: width, height: width)
    }
    
    func getCountSearchResults() -> Int {
        return self.listSearchResults.count
    }
}
