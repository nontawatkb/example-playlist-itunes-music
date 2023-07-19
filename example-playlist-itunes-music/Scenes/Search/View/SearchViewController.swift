//
//  SearchViewController.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 19/7/2566 BE.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModel = SearchViewModel()
    
    let collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.barStyle = .default
        view.searchBarStyle = .minimal
        view.placeholder = "Search .."
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        setupUI()
        setupCollectionView()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateUIConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        updateUIConstraints()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
    }
    
    private func updateUIConstraints() {
        let guide = view.safeAreaLayoutGuide
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        collectionView.reloadData()
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.searchTextField.endEditing(true)
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("collectionView")
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) 
        cell.backgroundColor = .lightGray
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var countPerWith = 2
        if UIDevice.current.orientation.isLandscape || UIDevice.current.orientation.isFlat {
            countPerWith = 3
        }
        let width = (Int(collectionView.frame.width) / countPerWith) - 10
        
        return CGSize(width: width, height: width)
    }
    
}
