//
//  UIColor+HexValue.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/22.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(rgbHex: Int) {
    let red = CGFloat((rgbHex >> 16) & 0xFF) / 255.0
    let green = CGFloat((rgbHex >> 8) & 0xFF) / 255.0
    let blue = CGFloat(rgbHex & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}
