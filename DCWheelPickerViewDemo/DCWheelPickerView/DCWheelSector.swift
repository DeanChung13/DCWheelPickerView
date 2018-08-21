//
//  DCWheelSector.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelSector {
  lazy var minValue: CGFloat = {
    return midValue - fanWidth/2
  }()

  lazy var maxValue: CGFloat = {
    var result = midValue + fanWidth/2
    if result > CGFloat.pi {
      result = -(2*CGFloat.pi - result)
    }
    return result
  }()

  lazy var arcStartAngle: CGFloat = {
    return -maxValue
  }()
  lazy var arcEndAngle: CGFloat = {
    return -minValue
  }()
  lazy var labelAngle: CGFloat = {
    return -midValue + CGFloat.pi/2
  }()

  let midValue: CGFloat
  let index: Int

  private let fanWidth: CGFloat

  init(index: Int, fanWidth: CGFloat) {
    var mid = CGFloat(index) * -fanWidth + CGFloat.pi
    if mid > CGFloat.pi {
      mid = -(2*CGFloat.pi - CGFloat(index)*fanWidth)
    }

    self.midValue = mid
    self.fanWidth = fanWidth
    self.index = index
  }
  func calculateMid(value: CGFloat) -> CGFloat {
    var result = value
    if value > 0 {
      result = -2*CGFloat.pi + value
    }
    return result
  }
}

extension DCWheelSector: CustomStringConvertible {
  var description: String {
    return "Sector\(index): (min, mid, max) = (\(minValue),\(midValue),\(maxValue))"
  }
}
