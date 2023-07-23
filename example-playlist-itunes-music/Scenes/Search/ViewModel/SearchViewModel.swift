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
    
    func getNumberOfSections(_ collectionView: UICollectionView) -> Int
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
    weak var viewController: UIViewController?
    private var searchText: String?

    init(viewController: UIViewController,
         getSearchUseCase: GetSearchUseCase = GetSearchUseCaseImpl()) {
        self.viewController = viewController
        self.getSearchUseCase = getSearchUseCase
    }
    
    deinit {
        debugPrint("🔅 Deinitialized. \(String(describing: self))")
    }
    
    // MARK: - Data-binding OutPut
    var didUpdateTableView: (() -> Void)?
    var didUpdateLoadingView: ((Bool) -> Void)?

}

// MARK: - Input
extension SearchViewModel: SearchProtocolInput {
    func getSearch(text: String?) {
        guard let term = text else { return }
        self.searchText = term
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
        previewController.configure(searchItem: self.listSearchResults[indexPath.row])
        viewController?.present(previewController, animated: true)
    }
}

// MARK: - OutPut
extension SearchViewModel: SearchProtocolOutput {
    
    func getNumberOfSections(_ collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func getNumberOfRowsInSection(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.listSearchResults.isEmpty ? 0 : 1
        } else {
            return self.listSearchResults.count
        }
    }
    
    func getCellForRowAt(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultSearchCollectionViewCell.identifier, for: indexPath) as! ResultSearchCollectionViewCell
            cell.searchText = self.searchText
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistItemCollectionViewCell.identifier, for: indexPath) as! PlaylistItemCollectionViewCell
            cell.data = self.listSearchResults[indexPath.row]
            return cell
        }
    }
    
    func getSizeForItemAt(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = collectionView.frame.width - 16
            return CGSize(width: width, height: 45)
        } else {
            var countPerWith = 2
            if UIDevice.current.orientation.isLandscape || UIDevice.current.orientation.isFlat {
                countPerWith = 3
            }
            let cgCountPerWith = CGFloat(countPerWith)
            let removeWidth = ((cgCountPerWith - 1.0) * 8.0) / cgCountPerWith
            let width = ((collectionView.frame.width - 16.0) / cgCountPerWith) - removeWidth
            return CGSize(width: width, height: width)
        }
    }
    
    func getCountSearchResults() -> Int {
        return self.listSearchResults.count
    }
}
