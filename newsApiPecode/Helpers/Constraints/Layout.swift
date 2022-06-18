//
//  Layout.swift
//  Nervy
//
//  Created by Oleksiy Humenyuk on 3/25/19.
//  Copyright © 2019 Oleksiy Humenyuk. All rights reserved.
//

import UIKit

public protocol Layout {
    /// Manage UIView's layout
    ///
    /// - Parameter manager: manage constraints of your view
    func layout(with manager: (LayoutManager)->Void)
}

public protocol LayoutSizeable {
    /// Constraint sizes for view
    /// - Note: view will be constrained with fixed sizes and automaticaly be activated constraints
    /// - Parameter sizes: choose width or height, or both, with sizes you need
    /// - Returns: array of created constraints(in appropriate order)
    func size(_ sizes: LayoutSize...) -> [NSLayoutConstraint]
}

public protocol EdgeConstrainable {
    /// Set appropriate constraints to view into targetView
    /// - Note: view will be constrained with fixed offset and automaticaly be activated constraints
    /// - Parameters:
    ///   - targetView: to which you want to attach
    ///   - edges: mutual edge point for view and targetView
    /// - Returns: array of created constraints(in appropriate order)
    func constraint(to targetView: UIView, by edges: LayoutEdgePoint...) -> [NSLayoutConstraint]
}

public protocol LayoutAnchor {
    func constraint(equalTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: LayoutAnchor { }


// MARK: - Layout
extension UIView: Layout {
    public func layout(with manager: (LayoutManager) -> Void) {
        allowAutoLayout()
        manager(LayoutManager(for: self))
    }
}

// MARK: -
public class LayoutManager: LayoutSizeable, EdgeConstrainable {
    
    // MARK: - Properties
    private let view: UIView
    
    // MARK: - Anchors
    // XAxis
    public lazy var trailing = Anchor(with: view.trailingAnchor)
    public lazy var leading = Anchor(with: view.leadingAnchor)
    
    // YAxis
    public lazy var top = Anchor(with: view.topAnchor)
    public lazy var bottom = Anchor(with: view.bottomAnchor)
    
    // Center
    public lazy var centerX = Anchor(with: view.centerXAnchor)
    public lazy var centerY = Anchor(with: view.centerYAnchor)
    
    // MARK: - Constructor
    public init(for view: UIView) {
        self.view = view
    }
    
    // MARK: - Methods
    @discardableResult
    public func size(_ sizes: LayoutSize...) -> [NSLayoutConstraint] {
        return sizes.map { view.constraintSize($0) }
    }
    
    @discardableResult
    public func constraint(to targetView: UIView, by edges: LayoutEdgePoint...) -> [NSLayoutConstraint] {
        return edges.map { view.constraint(to: targetView, by: $0) }
    }
}

// MARK: - Sizes constraint
extension UIView {
    fileprivate func constraintSize(_ size: LayoutSize) -> NSLayoutConstraint {
        return anchor(for: size)
            .constraint(equalToConstant: size.offset)
            .activate()
    }
    
    private func anchor(for layout: LayoutSize) -> NSLayoutDimension {
        switch layout {
        case .height:
            return heightAnchor
        case .width:
            return widthAnchor
        }
    }
}

// MARK: - Edge constraint
extension UIView {
    fileprivate func constraint(to view: UIView, by edge: LayoutEdgePoint) -> NSLayoutConstraint {
        switch edge {
        case .top, .bottom:
            guard let point = edge.verticalPoint else {
                fatalError("Can't convert to VerticalPoint")
            }
            
            return anchor(for: point)
                .constraint(equalTo: view.anchor(for: point), constant: edge.offset)
                .activate()
        case .leading, .trailing:
            guard let edgePoint = edge.horizontalPoint else {
                fatalError("Can't convert to HorizontalPoint")
            }
            
            return anchor(for: edgePoint)
                .constraint(equalTo: view.anchor(for: edgePoint), constant: edge.offset)
                .activate()
        }
    }
    
    public func anchor(for horizontal: HorizontalPoint) -> NSLayoutAnchor<NSLayoutXAxisAnchor> {
        switch horizontal {
        case .leading:
            return leadingAnchor
        case .trailing:
            return trailingAnchor
        case .centerX:
            return centerXAnchor
        }
    }
    
    public func anchor(for vertical: VerticalPoint) -> NSLayoutAnchor<NSLayoutYAxisAnchor> {
        switch vertical {
        case .top:
            return topAnchor
        case .bottom:
            return bottomAnchor
        case .centerY:
            return centerYAnchor
        }
    }
}
