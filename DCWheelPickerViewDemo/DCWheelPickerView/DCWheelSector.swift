//
//  DCWheelSector.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelSector {
  var minValue: CGFloat {
    return midValue - fanWidth/2
  }
  var maxValue: CGFloat {
    return midValue + fanWidth/2
  }
  var labelAngle: CGFloat {
    return midValue + CGFloat.pi/2
  }
  let midValue: CGFloat
  let index: Int
  private let fanWidth: CGFloat


  init(midValue: CGFloat, fanWidth: CGFloat, index: Int) {
    self.midValue = midValue
    self.fanWidth = fanWidth
    self.index = index
  }
}

extension DCWheelSector: CustomStringConvertible {
  var description: String {
    return "Sector\(index): (min, mid, max) = (\(minValue),\(midValue),\(maxValue))"
  }
}
