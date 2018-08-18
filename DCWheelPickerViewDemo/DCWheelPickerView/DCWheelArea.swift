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

  private var outerRadius: CGFloat {
    return outerFrame.width / 2.0
  }

  private var innerRadius: CGFloat {
    return innerFrame.width / 2.0
  }

  private var centerRadius: CGFloat {
    return centerFrame.width / 2.0
  }

  enum TouchArea {
    case outer
    case inner
    case center
    case none
  }
  private let rect: CGRect

  init(rect: CGRect) {
    self.rect = rect
  }

  private func padding(ratio: WheelSizeRatio) -> CGFloat {
    return (rect.width * ( 1 - ratio.rawValue )) / 2
  }

  func detectTouchArea(with point: CGPoint) -> TouchArea {
    let distance = distanceFromCenter(to: point)
    switch distance {
    case  0 ... centerRadius:
      return .center
    case centerRadius ... innerRadius:
      return .inner
    case innerRadius ... outerRadius:
      return .outer
    default:
      return .none
    }
  }

  private func distanceFromCenter(to touchPoint: CGPoint) -> CGFloat {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let dx = Float(touchPoint.x - center.x)
    let dy = Float(touchPoint.y - center.y)
    return CGFloat(sqrtf(dx*dx + dy*dy))
  }



}
