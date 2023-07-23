//
//  UIViewController+Extension.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 22/7/2566 BE.
//

import UIKit

extension UIViewController {
    
    func startLoadingView(spinnerView: UIViewController) {
        addChild(spinnerView)
        spinnerView.view.frame = view.frame
        view.addSubview(spinnerView.view)
        spinnerView.didMove(toParent: self)
    }
    
    func stopLoadingView(spinnerView: UIViewController) {
        spinnerView.willMove(toParent: nil)
        spinnerView.view.removeFromSuperview()
        spinnerView.removeFromParent()
    }
    
}
