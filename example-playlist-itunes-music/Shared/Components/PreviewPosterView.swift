//
//  PreviewPosterView.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 22/7/2566 BE.
//

import Foundation
import Kingfisher
import UIKit

public class PreviewPosterView: UIView {
    
    private let imagePoster: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "placeholder")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var onChangeBackgroundColor: ((UIColor?) -> Void)?
    
    var imageURL: String? {
        didSet {
            setupValue()
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
        self.addSubview(imagePoster)
        self.imagePoster.layer.cornerRadius = 5
        self.updateUIConstraints()
    }
    
    private func updateUIConstraints() {
        let guide = safeAreaLayoutGuide
        self.imagePoster.translatesAutoresizingMaskIntoConstraints = false
        self.imagePoster.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20).isActive = true
        self.imagePoster.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20).isActive = true
        self.imagePoster.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20).isActive = true
        self.imagePoster.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant:  -20).isActive = true
    }
    
    private func setupValue() {
        if let imageStr = imageURL, let urlImage = URL(string: "\(imageStr)") {
            imagePoster.kf.setImage(with: urlImage,
                                    placeholder: UIImage(named: "placeholder"),
                                    options: [
                                        .loadDiskFileSynchronously,
                                        .cacheOriginalImage,
                                        .transition(.fade(0.10))])
         
            let averageColor = imagePoster.image?.averageColor
            onChangeBackgroundColor?(averageColor)
        }
    }
}
