//
//  ResultSearchCollectionViewCell.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Foundation
import UIKit

class ResultSearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ResultSearchCollectionViewCell"
    
    var searchText: String? {
        didSet {
            guard let searchText = searchText, !searchText.isEmpty else {
                searchResultLabel.text = ""
                return
            }
            searchResultLabel.text = "Result Search: \(searchText)"
        }
    }
    
    private let stackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.backgroundColor = .clear
        return view
    }()
    
    private let searchResultLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 16)
        view.textColor = .lightText
        return view
    }()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        stackViewContainer.addArrangedSubview(searchResultLabel)
        addSubview(stackViewContainer)
        updateUIConstraints()
    }
    
    private func updateUIConstraints() {
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        stackViewContainer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

