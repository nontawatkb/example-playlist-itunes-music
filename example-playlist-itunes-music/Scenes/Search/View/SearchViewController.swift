//
//  SearchViewController.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 19/7/2566 BE.
//

import UIKit

class SearchViewController: UIViewController {
    
    private(set) var viewModel: SearchViewModel!
    private let spinnerView = SpinnerViewController()
    
    lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.barStyle = .default
        view.searchBarStyle = .minimal
        view.placeholder = "Search .."
        view.delegate = self
        return view
    }()
    
    private let stackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.backgroundColor = .clear
        return view
    }()
    
    private let emptyLabel: UILabel = {
        let view = UILabel()
        view.text = "Not found data"
        view.textAlignment = .center
        view.textColor = .lightText
        return view
    }()
    
    private let collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        configure()
        setupUI()
        setupCollectionView()
        searchBar.text = "Taylor Swift"
        viewModel.input.getSearch(text: "Taylor Swift")
    }
    
    deinit {
        debugPrint("🔅 Deinitialized. \(String(describing: self))")
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateUIConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func configure() {
        viewModel = SearchViewModel(viewController: self)
        bindToViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(searchBar)
        view.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(emptyLabel)
        stackViewContainer.addArrangedSubview(collectionView)
        emptyLabel.isHidden = true
        updateUIConstraints()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.register(PlaylistItemCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistItemCollectionViewCell.identifier)
        collectionView.register(ResultSearchCollectionViewCell.self, forCellWithReuseIdentifier: ResultSearchCollectionViewCell.identifier)
    }
    
    private func updateUIConstraints() {
        let guide = view.safeAreaLayoutGuide
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        stackViewContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        stackViewContainer.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        stackViewContainer.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        stackViewContainer.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        emptyLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}

// MARK: - Binding
extension SearchViewController {
    func bindToViewModel() {
        viewModel.output.didUpdateTableView = didUpdateTableView()
        viewModel.output.didUpdateLoadingView = didUpdateLoadingView()
    }
    
    func didUpdateTableView() -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            if viewModel.output.getCountSearchResults() == 0 {
                self.emptyLabel.isHidden = false
            } else {
                self.emptyLabel.isHidden = true
            }
            self.collectionView.reloadData()
        }
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
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        emptyLabel.isHidden = true
        viewModel.input.getSearch(text: searchBar.text)
        searchBar.searchTextField.endEditing(true)
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.output.getNumberOfSections(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.didSelectItemAt(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.getNumberOfRowsInSection(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return viewModel.output.getCellForRowAt(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.output.getSizeForItemAt(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
}

