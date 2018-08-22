//
//  DCWheelGestureTrack.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/20.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelGestureTrack {
  var beginPoint = CGPoint.zero {
    didSet {
      isTapped = true
    }
  }
  var changePoint = CGPoint.zero {
    didSet {
      isTapped = false
    }
  }
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
  var radiansDifference: CGFloat {
    return -(changePolarPoint.radians - beginPolarPoint.radians)
  }

  var isTapped: Bool = true

  weak var transformView: UIView?

  init(centerPoint: CGPoint) {
    self.centerPoint = centerPoint
  }
}
