//
//  LayoutEnums.swift
//  Nervy
//
//  Created by Oleksiy Humenyuk on 3/26/19.
//  Copyright © 2019 Oleksiy Humenyuk. All rights reserved.
//

import UIKit

protocol Offsetable {
    var offset: CGFloat { get }
}

extension Offsetable {
    public var offset: CGFloat {
        let value = Mirror(reflecting: self).children.first?.value as? CGFloat
        return value ?? 0
    }
}

public enum LayoutSize: Offsetable  {
    case height(CGFloat)
    case width(CGFloat)
}

public enum LayoutEdgePoint: Offsetable {
    case top(CGFloat)
    case bottom(CGFloat)
    
    case leading(CGFloat)
    case trailing(CGFloat)
    
    var verticalPoint: VerticalPoint? {
        switch self {
        case .top:
            return .top(offset)
        case .bottom:
            return .bottom(offset)
        default:
            return nil
        }
    }
    
    var horizontalPoint: HorizontalPoint? {
        switch self {
        case .leading:
            return .leading(offset)
        case .trailing:
            return .trailing(offset)
        default:
            return nil
        }
    }
}

public enum HorizontalPoint: Offsetable {
    case leading(CGFloat)
    case trailing(CGFloat)
    case centerX(CGFloat)
}

public enum VerticalPoint: Offsetable {
    case top(CGFloat)
    case bottom(CGFloat)
    case centerY(CGFloat)
}
