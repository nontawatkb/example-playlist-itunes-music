//
//  MainViewController.swift
//  example-playlist-itunes-music
//
//  Created by Nontawat Kanboon on 22/7/2566 BE.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    let buttonView: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("GO TO SEARCH PLAYLIST", for: .normal)
        view.tintColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 24)
        return view
    }()

    override func viewDidLoad() {
        setupUI()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        updateUIConstraints()
    }
    
    private func setupUI() {
        view.addSubview(buttonView)
        buttonView.addTarget(self, action: #selector(handleGoToSearch(_:)), for: .touchUpInside)
        updateUIConstraints()
    }
    
    private func updateUIConstraints() {
        let guide = view.safeAreaLayoutGuide
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        buttonView.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
    }
    
    @objc func handleGoToSearch(_ sender: UIButton) {
        let searchViewController = SearchViewController()
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
}
