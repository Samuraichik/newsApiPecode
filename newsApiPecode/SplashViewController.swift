//
//  SplashViewController.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let rootVC = NewsListViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
}
