//
//  DCWheelCenterView.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/17.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

class DCWheelCenterView: UIView {
  lazy var numberLabel: UILabel = {
    let templateText: NSString = "99"
    let font = UIFont.boldSystemFont(ofSize: 70)
    let size = templateText.size(withAttributes: [.font: font])
    let label = UILabel(frame: CGRect(origin: .zero, size: size))
    label.font = font
    label.text = "--"
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.backgroundColor = UIColor.clear
    return label
  }()

  private let borderImageView = UIImageView(image: UIImage(named: "O_inside"))

  override init(frame: CGRect) {
    super.init(frame: frame)
    drawCircle()
    addSubview(numberLabel)
    setupBorder()
    isUserInteractionEnabled = false
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    numberLabel.center = centerPoint
  }

  private func drawCircle() {
    let circleShapeLayer = CAShapeLayer()
    let path = UIBezierPath()
    path.addArc(withCenter: centerPoint,
                radius: bounds.width/2.0,
                startAngle: 0,
                endAngle: 2*CGFloat.pi,
                clockwise: true)
    path.close()
    circleShapeLayer.path = path.cgPath
    circleShapeLayer.fillColor = UIColor(rgbHex: 0xFD3589).cgColor
    layer.addSublayer(circleShapeLayer)
  }

  private func setupBorder() {
    let padding: CGFloat = -28.0
    borderImageView.frame = bounds.insetBy(dx: padding, dy: padding)
    addSubview(borderImageView)
  }

  func changeValue(number: Int) {
    let string = NSString(format: "%02d", number)
    numberLabel.text = string as String
  }
}

extension UIView {
  var centerPoint: CGPoint {
    return CGPoint(x: bounds.midX, y: bounds.midY)
  }
}
