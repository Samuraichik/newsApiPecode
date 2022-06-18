//
//  ReusableCell.swift
//  newsApiPecode
//
//  Created by Oleksiy Humenyuk on 14.06.2022.
//

import Foundation
import UIKit

protocol ReusableCell where Self: UITableViewCell {
    static var reuseIdentifier: String {get}
    static func register(for tableView: UITableView)
}

extension ReusableCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static func register(for tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    static func deque(for tableView: UITableView, indexPath: IndexPath) -> Self? {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? Self
    }
}
