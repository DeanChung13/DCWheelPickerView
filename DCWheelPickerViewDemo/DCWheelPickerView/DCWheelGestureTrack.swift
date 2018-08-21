//
//  DCWheelGestureTrack.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/20.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelGestureTrack {
  var beginPoint = CGPoint.zero
  var changePoint = CGPoint.zero
  var endPoint: CGPoint? = CGPoint.zero
  var centerPoint = CGPoint.zero
  var startTransform = CGAffineTransform.identity

  var beginPolarPoint: DCPolarPoint {
    return DCPolarPoint(cartesianOriginalPoint: centerPoint, relativePoint: beginPoint)
  }

  var changePolarPoint: DCPolarPoint {
    return DCPolarPoint(cartesianOriginalPoint: centerPoint, relativePoint: changePoint)
  }

  var endPolarPoint: DCPolarPoint {
    return DCPolarPoint(cartesianOriginalPoint: centerPoint, relativePoint: endPoint ?? CGPoint.zero)
  }
  var angleDifference: CGFloat {
    return changePolarPoint.angle - beginPolarPoint.angle
  }

  var isTapped: Bool {
    guard let existingEndPoint = endPoint else { return false }
    let dx = existingEndPoint.x - beginPoint.x
    let dy = existingEndPoint.y - beginPoint.y
    let distance = CGFloat(sqrtf(Float(dx*dx + dy*dy)))
    return distance < 5
  }

  weak var transformView: UIView?

  init(centerPoint: CGPoint) {
    self.centerPoint = centerPoint
  }
}
