//
//  DCWheelSector.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import Foundation

class DCWheelSector {
  let minValue: Float
  let maxValue: Float
  let midValue: Float
  let index: Int

  init(midValue: Float, fanWidth: Float, index: Int) {
    var newMinValue = midValue - fanWidth/2
    let newMaxValue = midValue + fanWidth/2
    var newMidValue = midValue

    if newMaxValue-fanWidth < -Float.pi {
      newMidValue = Float.pi
      newMinValue = fabsf(newMaxValue)
    }

    self.midValue = newMidValue
    self.minValue = newMinValue
    self.maxValue = newMaxValue
    self.index = index
  }
}

extension DCWheelSector: CustomStringConvertible {
  var description: String {
    return "Sector\(index): (min, mid, max) = (\(minValue),\(midValue),\(maxValue))"
  }
}
