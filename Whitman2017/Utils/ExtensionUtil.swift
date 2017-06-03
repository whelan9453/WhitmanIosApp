//
//  ExtensionUtil.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/4/9.
//  Copyright © 2017年 Orav. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func rounding() {
        layer.cornerRadius = bounds.size.width / 2.0
    }
    
    func bordering(with color: UIColor, size: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = size        
    }
}

extension UIImage {
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

extension UINavigationController {
    func setGradientBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
        
        let barView = UIView(frame: navigationBar.frame)
        if let root = view.window?.rootViewController {
            if root == self {
                barView.frame.origin.y -= 20
            }
        }
        let gradientLayer = [UIColor(hex: "#3E3935"), UIColor(hex: "#231F20")].gradient { [unowned self] gradient in
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.frame = self.navigationBar.bounds
            gradient.frame.size.height += 20    // status bar height
            return gradient
        }
        barView.layer.insertSublayer(gradientLayer, at: 0)
        view.insertSubview(barView, belowSubview: navigationBar)
    }
}
