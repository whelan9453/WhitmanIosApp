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
}
