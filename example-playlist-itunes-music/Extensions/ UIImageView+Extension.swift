//
//  UIImageView+Extension.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 21/7/2566 BE.
//

import Foundation
import UIKit

extension UIImageView {
    public func setPlaceholderImageView () {
        self.image = UIImage(named: "placeholder")
        self.contentMode = .scaleAspectFill
    }
}

