//
//  AmityColorSet.swift
//  AmityUIKit
//
//  Created by Sarawoot Khunsri on 15/6/2563 BE.
//  Copyright © 2563 Amity Communication. All rights reserved.
//

import UIKit

struct AmityColorSet {
    static var backgroundBlue: UIColor {
        UIColor(red: 18.0 / 255.0, green: 42.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
    }
    
    static var blue: UIColor {
        UIColor(red: 57.0 / 255.0, green: 69.0 / 255.0, blue: 111.0 / 255.0, alpha: 1.0)
    }

    static let textGray = UIColor(red: 161.0 / 255.0, green: 161.0 / 255.0, blue: 161.0 / 255.0, alpha: 1.0)
    static let yourUserIndicatorBackgroundColor = UIColor(
        red: 102.0 / 255.0,
        green: 117.0 / 255.0,
        blue: 172.0 / 255.0,
        alpha: 1.0
    )

    // 95A1CD
    static var lightBlue: UIColor {
        UIColor(red: 149.0 / 255.0, green: 161.0 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)
    }

    static var ownerMessageColor: UIColor {
        UIColor(red: 117.0 / 255.0, green: 121.0 / 255.0, blue: 207.0 / 255.0, alpha: 1.0)
    }

    static var primary: UIColor {
        return AmityThemeManager.currentTheme.primary
    }
    static var secondary: UIColor {
        return AmityThemeManager.currentTheme.secondary
    }
    static var alert: UIColor {
        return AmityThemeManager.currentTheme.alert
    }
    static var highlight: UIColor {
        return AmityThemeManager.currentTheme.highlight
    }
    static var base: UIColor {
        return AmityThemeManager.currentTheme.base
    }
    static var baseInverse: UIColor {
        return AmityThemeManager.currentTheme.baseInverse
    }
    static var messageBubble: UIColor {
        return AmityThemeManager.currentTheme.messageBubble
    }
    static var messageBubbleInverse: UIColor {
        return AmityThemeManager.currentTheme.messageBubbleInverse
    }
    
    static var backgroundColor: UIColor {
        return .clear
    }
}
