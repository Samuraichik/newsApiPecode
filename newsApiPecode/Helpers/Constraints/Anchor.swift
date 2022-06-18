//
//  Anchor.swift
//  Nervy
//
//  Created by Oleksiy Humenyuk on 3/26/19.
//  Copyright © 2019 Oleksiy Humenyuk. All rights reserved.
//

import UIKit

public struct Anchor<A: LayoutAnchor> {
    fileprivate let anchor: A
    
    init(with anchor: A) {
        self.anchor = anchor
    }
}

// MARK: - XAxis constraint
extension Anchor where A == NSLayoutXAxisAnchor {
    /// Create new constraint for anchor
    ///
    /// - Parameters:
    ///   - targetView: to which you want to attach
    ///   - anchorPoint: horizontal point at targetView
    @discardableResult
    public func constraint(to targetView: UIView,
                           by anchorPoint: HorizontalPoint,
                           priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let anch = anchor
            .constraint(equalTo: targetView.anchor(for: anchorPoint),
                        constant: anchorPoint.offset)
        anch.priority = priority
        return anch.activate()
    }
}

// MARK: - YAxis constraint
extension Anchor where A == NSLayoutYAxisAnchor {
    /// Create new constraint for anchor
    ///
    /// - Parameters:
    ///   - targetView: to which you want to attach
    ///   - anchorPoint: vertical point at targetView
    @discardableResult
    public func constraint(to targetView: UIView,
                           by anchorPoint: VerticalPoint,
                           priority: UILayoutPriority = .defaultHigh,
                           anchorSign: Sign = .equal) -> NSLayoutConstraint {
        
        var anch: NSLayoutConstraint!
        
        switch anchorSign {
        case .equal:
            anch = anchor
            .constraint(equalTo: targetView.anchor(for: anchorPoint),
                        constant: anchorPoint.offset)
        case .greaterOrEqual:
            anch = anchor.constraint(greaterThanOrEqualTo: targetView.anchor(for: anchorPoint), constant: anchorPoint.offset)
        case .lessOrEqual:
            anch = anchor.constraint(lessThanOrEqualTo: targetView.anchor(for: anchorPoint), constant: anchorPoint.offset)
        }
        
        anch.priority = priority
        return anch.activate()
    }
}

public extension Anchor {
    enum Sign {
        case equal
        case lessOrEqual
        case greaterOrEqual
    }
}
