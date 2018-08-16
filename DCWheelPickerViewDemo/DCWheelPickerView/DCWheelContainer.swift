//
//  DCWheelContainer.swift
//  DCWheelPickerViewDemo
//
//  Created by DeanChung on 2018/8/16.
//  Copyright © 2018 DeanChung. All rights reserved.
//

import UIKit

enum WheelContainerStyle {
  case outside, inside
}

class DCWheelContainerView: UIView {
  private var radius: CGFloat {
    return frame.size.width / 2.0
  }
  private var selectedIndex: Int = 5
  private var maxNumber: Int = 0
  private let numberOfSectors = 10
  private lazy var sectors: [DCWheelSector] = {
    var sectors: [DCWheelSector] = []
    sectors.reserveCapacity(numberOfSectors)
    return sectors
  }()
  private var style: WheelContainerStyle

  let sectorColor1 = UIColor(rgbHex: 0x59636F).cgColor
  let sectorColor2 = UIColor(rgbHex: 0x90A6BC).cgColor
  let sectorSelectedColor = UIColor(rgbHex: 0x55BFE7).cgColor

  init(frame: CGRect, style: WheelContainerStyle = .outside) {
    self.style = style
    super.init(frame: frame)
    self.backgroundColor = UIColor.clear
    buildSectors()
    drawWheel()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func buildSectors() {
    var mid: Float = 0
    for i in 0 ..< numberOfSectors {
      let sector = DCWheelSector(midValue: mid, fanWidth: fanWidth(), index: i)
      mid -= fanWidth()
      sectors.append(sector)
    }
  }

  private func fanWidth() -> Float {
    return Float.pi * 2 / Float(numberOfSectors)
  }

  override func draw(_ rect: CGRect) {

  }

  private func drawWheel() {
    doWithAllSectors(drawSector)
    doWithAllSectors(addSectorTextLabel)
//    doWithAllSectors(drawSectorTextLayer)
  }


  private func doWithAllSectors(_ action: (Int) -> Void) {
    for index in 0 ..< numberOfSectors {
      action(index)
    }
  }

  private func drawSector(index: Int) {
    let sectorLayer = CAShapeLayer()
    let path = UIBezierPath()
    path.move(to: centerPoint)
    let mid = Float(index) * fanWidth()
    let startAngle = CGFloat(mid - fanWidth()/2)
    let endAngle = CGFloat(mid + fanWidth()/2)
    path.addArc(withCenter: centerPoint,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true)
    path.close()
    sectorLayer.path = path.cgPath

    fillColor(layer: sectorLayer, index: index)
    layer.addSublayer(sectorLayer)
  }

  private func fillColor(layer: CAShapeLayer, index: Int) {
    guard selectedIndex != index else {
      layer.fillColor = sectorSelectedColor
      return
    }
    let color1 = (style == .outside) ? sectorColor1 : sectorColor2
    let color2 = (style == .outside) ? sectorColor2 : sectorColor1
    layer.fillColor = (index % 2 == 0) ? color1 : color2
  }

  private func addSectorTextLabel(index: Int) {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
    label.font = UIFont.boldSystemFont(ofSize: 26)
    label.backgroundColor = UIColor.clear
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.text = "\(index)"
    label.layer.anchorPoint = CGPoint(x: 0.5, y: 1.3)
    label.layer.position = centerPoint
    label.transform = CGAffineTransform.identity
      .rotated(by: CGFloat(midAngle(index: index)-Float.pi/2))
    addSubview(label)
  }

  private func drawSectorTextLayer(index: Int) {
    let textLayer = CATextLayer()
    textLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
    textLayer.contentsScale = UIScreen.main.scale
    textLayer.font = UIFont.boldSystemFont(ofSize: 26)
    textLayer.backgroundColor = UIColor.clear.cgColor
    textLayer.foregroundColor = UIColor.white.cgColor
    textLayer.alignmentMode = .center
    textLayer.string = "\(index)"
    textLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
    textLayer.position = centerPoint
    textLayer.setAffineTransform(CGAffineTransform.identity
      .rotated(by: CGFloat(midAngle(index: index)-Float.pi/2)))
    layer.addSublayer(textLayer)
  }

  private func midAngle(index: Int) -> Float {
    return Float(index) * fanWidth()
  }

}

extension UIColor {
  convenience init(rgbHex: Int) {
    let red = CGFloat((rgbHex >> 16) & 0xFF) / 255.0
    let green = CGFloat((rgbHex >> 8) & 0xFF) / 255.0
    let blue = CGFloat(rgbHex & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}
