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

  override init(frame: CGRect) {
    super.init(frame: frame)
    drawCircle()
    addSubview(numberLabel)
    drawBorder()
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
    let path = UIBezierPath(ovalIn: bounds)
    circleShapeLayer.path = path.cgPath
    circleShapeLayer.fillColor = UIColor(rgbHex: 0xFD3589).cgColor
    layer.addSublayer(circleShapeLayer)
  }

  private func drawBorder() {
    addArrow()
    let borderLayer = CAShapeLayer()
    let path = UIBezierPath(ovalIn: bounds)
    borderLayer.path = path.cgPath
    borderLayer.fillColor = UIColor.clear.cgColor
    borderLayer.strokeColor = UIColor.white.cgColor
    borderLayer.lineWidth = 4.0
    borderLayer.shadowColor = UIColor.darkGray.cgColor
    borderLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    borderLayer.shadowOpacity = 0.8
    layer.addSublayer(borderLayer)
  }

  private func addArrow() {
    let arrowLayer = CAShapeLayer()
    let path = UIBezierPath()
    let triangleHeight: CGFloat = 13
    let triangleTopPoint = CGPoint(x: -triangleHeight, y: bounds.height/2)
    path.move(to: triangleTopPoint)
    path.addLine(to: CGPoint(x: 0, y: bounds.height/2+triangleHeight))
    path.addLine(to: CGPoint(x: 0, y: bounds.height/2-triangleHeight))
    path.addLine(to: triangleTopPoint)
    path.close()
    arrowLayer.path = path.cgPath
    arrowLayer.fillColor = UIColor.white.cgColor
    layer.addSublayer(arrowLayer)
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
