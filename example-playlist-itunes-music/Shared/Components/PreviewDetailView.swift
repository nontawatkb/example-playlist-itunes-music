//
//  PreviewDetailView.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Foundation
import Kingfisher
import UIKit

public class PreviewDetailView: UIView {
    
    private let stackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    private let trackNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = .systemFont(ofSize: 23)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    private let artistNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 16)
        view.textColor = .lightText
        view.textAlignment = .center
        return view
    }()
    
    var artistName: String? {
        didSet {
            artistNameLabel.text = artistName
        }
    }
    
    var trackName: String? {
        didSet {
            trackNameLabel.text = trackName
        }
    }

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateUIConstraints()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        self.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(trackNameLabel)
        stackViewContainer.addArrangedSubview(artistNameLabel)
        self.updateUIConstraints()
    }
    
    private func updateUIConstraints() {
        self.stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.stackViewContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.stackViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        self.stackViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        self.stackViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

