//
//  Double+Extension.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 23/7/2566 BE.
//

import Foundation
import UIKit

extension Double {
    func formatToTime() -> String? {
        if self > 60 {
            return "1:00"
        } else {
            return "0:\(Int(self.rounded()))"
        }
    }
}
