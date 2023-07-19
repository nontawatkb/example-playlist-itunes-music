//
//  PreviewController.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 19/7/2566 BE.
//

import UIKit

class PreviewController: UIViewController {
    
    private let viewModel: PreviewViewModel = PreviewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("PreviewController")
        view.backgroundColor = .lightGray
    }

}
