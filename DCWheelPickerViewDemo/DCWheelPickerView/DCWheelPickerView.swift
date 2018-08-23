//
//  DCWheelPickerView.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit
typealias DCWheelPickerViewDidSelectIndexCompletion = (Int) -> Void
typealias DCWheelPickerViewDidTapCenterCompletion = () -> Void
class DCWheelPickerView: UIControl {
  var didSelectIndexCompletion: DCWheelPickerViewDidSelectIndexCompletion?
  var didTapCenterCompletion: DCWheelPickerViewDidTapCenterCompletion?
  // MARK: initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupWheelContainer()
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

  // MARK: lazy properties
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

  private lazy var gestureTrack: DCWheelGestureTrack = {
    return DCWheelGestureTrack(centerPoint: CGPoint(x: bounds.midX, y: bounds.midY))
  }()
}

// MARK: Gesture Tracking
extension DCWheelPickerView {
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let touchPoint = touch.location(in: self)
    gestureTrack.beginPoint = touchPoint

    let touchArea = wheelArea.detectTouchArea(with: gestureTrack.beginPolarPoint)
    wheelArea.startTouchArea = touchArea
    switch touchArea {
    case .outer:
      gestureTrack.startTransform = outerWheel.transform
    case .inner:
      gestureTrack.startTransform = innerWheel.transform
    default: break
    }
    return true
  }


  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let touchPoint = touch.location(in: self)
    gestureTrack.changePoint = touchPoint

    let touchArea = wheelArea.detectTouchArea(with: gestureTrack.changePolarPoint)
    switch touchArea {
    case .outer:
      if wheelArea.startTouchArea == .outer {
        outerWheel.transform = gestureTrack.startTransform.rotated(by: gestureTrack.radiansDifference)
      }
    case .inner:
      if wheelArea.startTouchArea == .inner {
        innerWheel.transform = gestureTrack.startTransform.rotated(by: gestureTrack.radiansDifference)
      }
    default: break
    }
    return true
  }

  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    let touchPoint = touch?.location(in: self)
    gestureTrack.endPoint = touchPoint

    endSelectWheel(with: wheelArea.startTouchArea)

    if wheelArea.startTouchArea == .center {
      didTapCenterCompletion?()
    }
  }

  private func endSelectWheel(with area: DCWheelArea.TouchArea) {
    guard area == .outer || area == .inner else { return }

    let outerIndex = outerWheel.detectIndex(gestureTrack: (area == .outer) ? gestureTrack : nil)
    let innerIndex = innerWheel.detectIndex(gestureTrack: (area == .inner) ? gestureTrack : nil)
    let result  = 10*outerIndex + innerIndex

    outerWheel.alignmentToNewSector()
    innerWheel.alignmentToNewSector()

    centerWheel.changeValue(number: result)
    didSelectIndexCompletion?(result)
  }
}
