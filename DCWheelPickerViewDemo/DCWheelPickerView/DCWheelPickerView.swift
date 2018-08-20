//
//  DCWheelPickerView.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelPickerView: UIControl {
  private lazy var wheelArea: DCWheelArea = {
    return DCWheelArea(rect: bounds)
  }()
  private lazy var innerWheel: DCWheelContainerView = {
    return DCWheelContainerView(frame: wheelArea.innerFrame,
                                style: .inside)
  }()
  private lazy var outerWheel: DCWheelContainerView = {
    return DCWheelContainerView(frame: wheelArea.outerFrame,
                                       style: .outside)
  }()
  private lazy var centerWheel: DCWheelCenterView = {
    return DCWheelCenterView(frame: wheelArea.centerFrame)
  }()
  private var beginDragAngle: CGFloat = 0

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupWheelContainer()
//    setupGestureRecognizers()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupWheelContainer() {
    addSubview(outerWheel)
    addSubview(innerWheel)
    addSubview(centerWheel)
    centerWheel.changeValue(number: 0)
  }

  private func setupGestureRecognizers() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureRecognizer:)))
    tap.delegate = self
    addGestureRecognizer(tap)

    let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(gestureRecognizer:)))
    pan.delegate = self
    addGestureRecognizer(pan)
  }

  @objc private func tap(gestureRecognizer: UITapGestureRecognizer) {

  }

  @objc private func pan(gestureRecognizer: UIPanGestureRecognizer) {

  }

  private var startTransform = CGAffineTransform.identity
  private var startTouchArea: DCWheelArea.TouchArea = .none

  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let touchPoint = touch.location(in: self)
    let dx = touchPoint.x - bounds.midX
    let dy = touchPoint.y - bounds.midY
    beginDragAngle = atan2(dy, dx)
    let touchArea = wheelArea.detectTouchArea(with: touchPoint)
    switch touchArea {
    case .outer:
      startTransform = outerWheel.transform
      startTouchArea = .outer
    case .inner:
      startTransform = innerWheel.transform
      startTouchArea = .inner
    default:
      print("Do nothing")
    }
    return true
  }


  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let touchPoint = touch.location(in: self)
    let dx = touchPoint.x - bounds.midX
    let dy = touchPoint.y - bounds.midY
    let endDragAngle = atan2(dy, dx)
    let angleDifference = endDragAngle - beginDragAngle

    let touchArea = wheelArea.detectTouchArea(with: touchPoint)
    switch touchArea {
    case .outer:
      if startTouchArea == .outer {
        outerWheel.transform = startTransform.rotated(by: angleDifference)
      }
    case .inner:
      if startTouchArea == .inner {
        innerWheel.transform = startTransform.rotated(by: angleDifference)
      }
    case .center:
      print("touch center")
    case .none:
      print("Do nothing")
    }
    return true
  }

  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    print(#function)
    let touchPoint = touch?.location(in: self)
    let outerIndex = outerWheel.detectIndex(touchPoint: touchPoint)
    let innerIndex = innerWheel.detectIndex()

    if startTouchArea == .outer {

//      let tapIndex = outerWheel.detectIndex(touchPoint: point)
//      print("prepare rotate to tap number: \(tapIndex)")

      outerWheel.alignmentSector()
    } else if startTouchArea == .inner {
//      if isTap {
//      } else {
        innerWheel.alignmentSector()
//      }
    }

    let result  = 10*outerIndex + innerIndex
    centerWheel.changeValue(number: result)
  }
}

extension DCWheelPickerView: UIGestureRecognizerDelegate {
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
