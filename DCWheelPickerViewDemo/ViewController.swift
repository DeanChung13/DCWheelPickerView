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
    containerView.addSubview(wheelPicker)

    wheelPicker.didSelectIndexCompletion = { (index) in
      print("DidSelectIndex: \(index)")
    }
    wheelPicker.didTapCenterCompletion = {
      print("DidTapCenter")
    }
  }
}

