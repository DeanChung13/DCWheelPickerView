//
//  DCWheelPickerView.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelPickerView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupWheelContainer()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupWheelContainer() {
    let outsideWheelContainer = DCWheelContainerView(frame: bounds)
    addSubview(outsideWheelContainer)

    let padding: CGFloat = bounds.width / 6.0
    let insideWheelContainer = DCWheelContainerView(frame: bounds.insetBy(dx: padding, dy: padding),
                                                    style: .inside)
    addSubview(insideWheelContainer)

    let wheelCenterView = DCWheelCenterView(frame: bounds.insetBy(dx: padding*2, dy: padding*2))

    addSubview(wheelCenterView)
    wheelCenterView.changeValue(number: 0)
  }
}
