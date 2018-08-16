//
//  ViewController.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var containerView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    setupWheelPicker()
  }

  private func setupWheelPicker() {
    let wheelPicker = DCWheelPickerView(frame: containerView.bounds)
    wheelPicker.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(wheelPicker)
    let constraints = [
      wheelPicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      wheelPicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      wheelPicker.topAnchor.constraint(equalTo: containerView.topAnchor),
      wheelPicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }
}

