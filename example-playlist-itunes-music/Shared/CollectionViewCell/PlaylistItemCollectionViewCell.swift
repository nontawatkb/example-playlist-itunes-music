//
//  PlaylistItemCollectionViewCell.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 21/7/2566 BE.
//

import Foundation
import UIKit
import Kingfisher

class PlaylistItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PlaylistItemCollectionViewCell"
    
    var data: SearchItem? {
        didSet {
            setupValue()
        }
    }
    
    private let stackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.backgroundColor = .clear
        return view
    }()
    
    private let imagePoster: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "placeholder")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let trackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 3
        view.backgroundColor = .clear
        return view
    }()
    
    private let trackNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        return view
    }()
    
    private let artistNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.font = .systemFont(ofSize: 11)
        view.textColor = .lightText
        return view
    }()
    
    private let trackView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let iconPlayView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "play-button")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.isHidden = true
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
        stackViewContainer.addArrangedSubview(imagePoster)
        stackViewContainer.addArrangedSubview(trackView)
        imagePoster.contentMode = .scaleAspectFill
        imagePoster.clipsToBounds = true
        imagePoster.layer.cornerRadius = 5
        addSubview(stackViewContainer)
        trackView.addSubview(trackViewContainer)
        imagePoster.addSubview(iconPlayView)
        
        trackViewContainer.addArrangedSubview(trackNameLabel)
        trackViewContainer.addArrangedSubview(artistNameLabel)
        
        updateUIConstraints()
    }
    
    private func updateUIConstraints() {
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        stackViewContainer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        trackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        trackViewContainer.topAnchor.constraint(equalTo: trackView.topAnchor, constant: 8).isActive = true
        trackViewContainer.leadingAnchor.constraint(equalTo: trackView.leadingAnchor, constant: 8).isActive = true
        trackViewContainer.trailingAnchor.constraint(equalTo: trackView.trailingAnchor, constant: 8).isActive = true
        trackViewContainer.bottomAnchor.constraint(equalTo: trackView.bottomAnchor).isActive = true
        trackView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        iconPlayView.translatesAutoresizingMaskIntoConstraints = false
        iconPlayView.centerYAnchor.constraint(equalTo: imagePoster.centerYAnchor).isActive = true
        iconPlayView.centerXAnchor.constraint(equalTo: imagePoster.centerXAnchor).isActive = true
        iconPlayView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconPlayView.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupValue() {
        guard let data = data else { return }
        trackNameLabel.text = data.trackName
        artistNameLabel.text = data.artistName
        
        if let imageStr = data.artworkUrl100, let urlImage = URL(string: "\(imageStr)") {
            imagePoster.kf.setImage(with: urlImage,
                                    placeholder: UIImage(named: "placeholder"),
                                    options: [
                                        .loadDiskFileSynchronously,
                                        .cacheOriginalImage,
                                        .transition(.fade(0.10))])
            iconPlayView.isHidden = false
        } else {
            imagePoster.setPlaceholderImageView()
        }
    }
    
    @objc func handlePlayButton(_ sender: UIButton) {
        
    }
    
}
