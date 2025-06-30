//
//  File name: SimpleUIKitViewController.swift
//  Project name: api-request-example-ios
//  Workspace name: api-request-example-ios
//
//  Created by: nothing-to-add on 30/06/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation
import UIKit
import SwiftUI

class SimpleUIKitViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "UIKit View"
        
        let label = UILabel()
        label.text = "This is a simple UIKit view!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let swiftUIButton = UIButton(type: .system)
        swiftUIButton.setTitle("Go to SwiftUI View", for: .normal)
        swiftUIButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        swiftUIButton.backgroundColor = .systemBlue
        swiftUIButton.setTitleColor(.white, for: .normal)
        swiftUIButton.layer.cornerRadius = 8
        swiftUIButton.addTarget(self, action: #selector(swiftUITapped), for: .touchUpInside)
        swiftUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(closeButton)
        view.addSubview(swiftUIButton)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            swiftUIButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swiftUIButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            swiftUIButton.widthAnchor.constraint(equalToConstant: 200),
            swiftUIButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func swiftUITapped() {
        // Present SwiftUI view directly from this UIKit view controller
        let swiftUIView = SwiftUIExampleView { [weak self] in
            // Dismiss the presented SwiftUI view
            self?.dismiss(animated: true)
        }
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Configure the hosting controller
        hostingController.title = "SwiftUI View"
        
        // Present it with navigation
        let navigationController = UINavigationController(rootViewController: hostingController)
        present(navigationController, animated: true)
    }
}
