//
//  DCWheelSector.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelSector {
  let midValue: CGFloat
  let index: Int

  private let fanWidth: CGFloat

  // MARK: initializer
  init(index: Int, fanWidth: CGFloat) {
    let radians = CGFloat(index) * fanWidth
    self.midValue = CGFloat.pi - radians
    self.fanWidth = fanWidth
    self.index = index
  }

  // MARK: lazy properties
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
}

extension DCWheelSector: CustomStringConvertible {
  var description: String {
    return "Sector\(index): (min, mid, max) = (\(minValue),\(midValue),\(maxValue))"
  }
}
