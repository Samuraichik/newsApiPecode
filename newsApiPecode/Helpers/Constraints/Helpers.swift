//
//  Helpers.swift
//  Nervy
//
//  Created by Oleksiy Humenyuk on 3/26/19.
//  Copyright © 2019 Oleksiy Humenyuk. All rights reserved.
//

import UIKit

extension UIView {
    public func allowAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension NSLayoutConstraint {
    public func activate() -> NSLayoutConstraint {
        isActive = true
        return self
    }
    
   public func deactivate()  -> NSLayoutConstraint  {
        isActive = false
        return self
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
