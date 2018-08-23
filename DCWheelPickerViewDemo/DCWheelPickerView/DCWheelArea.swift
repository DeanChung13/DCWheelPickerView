//
//  DCWheelArea.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/17.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelArea {
  enum WheelSizeRatio: CGFloat, CaseIterable {
    case outer = 1.0
    case inner = 0.746
    case center = 0.339
  }

  enum TouchArea {
    case outer
    case inner
    case center
    case outOfRange
  }

  private var outerRadius: CGFloat {
    return outerFrame.width / 2.0
  }

  private var innerRadius: CGFloat {
    return innerFrame.width / 2.0
  }

  private var centerRadius: CGFloat {
    return centerFrame.width / 2.0
  }

  var startTouchArea: DCWheelArea.TouchArea = .outOfRange

  private let rect: CGRect

  // MARK: initializer
  init(rect: CGRect) {
    self.rect = rect
  }

  // MARK: lazy properties
  lazy var innerFrame: CGRect = {
    return rect.insetBy(dx: padding(ratio: .inner),
                        dy: padding(ratio: .inner))
  }()

  lazy var outerFrame: CGRect = {
    return rect.insetBy(dx: padding(ratio: .outer),
                        dy: padding(ratio: .outer))
  }()

  lazy var centerFrame: CGRect = {
    return rect.insetBy(dx: padding(ratio: .center),
                        dy: padding(ratio: .center))
  }()

  private func padding(ratio: WheelSizeRatio) -> CGFloat {
    return (rect.width * ( 1 - ratio.rawValue )) / 2
  }

  func detectTouchArea(with point: DCPolarPoint) -> TouchArea {
    switch point.radius {
    case  0 ... centerRadius:
      return .center
    case centerRadius ... innerRadius:
      return .inner
    case innerRadius ... outerRadius:
      return .outer
    default:
      return .outOfRange
    }
  }
}
