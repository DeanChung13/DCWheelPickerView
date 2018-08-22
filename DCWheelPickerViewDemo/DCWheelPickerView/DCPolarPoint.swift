//
//  DCPolarPoint.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/21.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

struct DCPolarPoint {
  let originPoint: CGPoint
  let relativePoint: CGPoint
  let radius: CGFloat
  let radians: CGFloat

  init(cartesianOriginalPoint originPoint: CGPoint, relativePoint: CGPoint) {
    let dx = relativePoint.x - originPoint.x
    let dy = relativePoint.y - originPoint.y
    self.radius = CGFloat(sqrtf(Float(dx*dx + dy*dy)))
    self.radians = -CGFloat(atan2(dy, dx))
    self.originPoint = originPoint
    self.relativePoint = relativePoint
  }
}
