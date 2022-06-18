//
//  UIViewController.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Navigation Bar SetUp
    func applyDefaultNavigationBar() {
        guard let navVc = (self as? UINavigationController) ?? navigationController else { return }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.yellow
        navVc.navigationBar.standardAppearance = appearance;
        navVc.navigationBar.scrollEdgeAppearance = navVc.navigationBar.standardAppearance
        navVc.navigationBar.isTranslucent = false
        navVc.navigationBar.tintColor = UIColor.black
    }
}
