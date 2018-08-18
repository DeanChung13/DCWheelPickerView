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
  private lazy var glassCover: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "glass"))
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 2, y: 2,
                             width: bounds.width/2, height: bounds.size.height)
    return imageView
  }()
  private var deltaAngle: CGFloat = 0

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
    addSubview(glassCover)
    addSubview(centerWheel)
//    wheelCenterView.changeValue(number: 0)
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
    deltaAngle = atan2(dy, dx)
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
    let changeAngle = atan2(dy, dx)
    let angleDifference = deltaAngle - changeAngle

    let touchArea = wheelArea.detectTouchArea(with: touchPoint)
    switch touchArea {
    case .outer:
      if startTouchArea == .outer {
        outerWheel.transform = startTransform.rotated(by: -angleDifference)
      }
    case .inner:
      if startTouchArea == .inner {
        innerWheel.transform = startTransform.rotated(by: -angleDifference)
      }
    case .center:
      print("touch center")
    case .none:
      print("Do nothing")
    }
    return true
  }

  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    if startTouchArea == .outer {
      let index = outerWheel.detectIndex()
      outerWheel.alignmentSector(index: index)
      print(index)
    } else if startTouchArea == .inner {
      let index = innerWheel.detectIndex()
      innerWheel.alignmentSector(index: index)
      print(index)
    }
  }

//  private func touchArea(touchPoint: CGPoint) -> TouchArea  {
//    let dist = distanceFromCenter(to: touchPoint)
//
//
//
//    switch dist {
//    case 0...
//    }
//  }

}

extension DCWheelPickerView: UIGestureRecognizerDelegate {
  override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
