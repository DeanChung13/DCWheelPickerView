//
//  DCRadiansAngleConvertible.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/22.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

protocol DCRadiansAngleConvertible {
  func degree(from radians: CGFloat) -> CGFloat
  func radians(from degree: CGFloat) -> CGFloat
}

extension DCRadiansAngleConvertible {
  func degree(from radians: CGFloat) -> CGFloat {
    return radians * 180.0 / CGFloat.pi
  }
  func radians(from degree: CGFloat) -> CGFloat {
    return degree * CGFloat.pi / 180.0
  }
}
