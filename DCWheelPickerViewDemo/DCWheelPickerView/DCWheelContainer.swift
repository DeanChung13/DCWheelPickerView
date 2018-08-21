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
  private var selectedIndex: Int = 0
  private var maxNumber: Int = 0
  private let numberOfSectors = 10
  private lazy var sectors: [DCWheelSector] = {
    var sectors: [DCWheelSector] = []
    sectors.reserveCapacity(numberOfSectors)
    return sectors
  }()
  private var style: WheelContainerStyle
  private var sectorLayers: [CAShapeLayer] = []

  let sectorColor1 = UIColor(rgbHex: 0x59636F).cgColor
  let sectorColor2 = UIColor(rgbHex: 0x90A6BC).cgColor
  let sectorSelectedColor = UIColor(rgbHex: 0x55BFE7).cgColor

  init(frame: CGRect, style: WheelContainerStyle = .outside) {
    self.style = style
    super.init(frame: frame)
    backgroundColor = UIColor.clear
    isUserInteractionEnabled = false
    buildSectors()
    drawWheel()
    setupBorder()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func buildSectors() {
    var mid = CGFloat.pi
    for i in 0 ..< numberOfSectors {
      let sector = DCWheelSector(index: i, fanWidth: fanWidth())
      mid += fanWidth()
      sectors.append(sector)
    }
  }

  private func fanWidth() -> CGFloat {
    return CGFloat.pi * 2 / CGFloat(numberOfSectors)
  }

  private func drawWheel() {
    doWithAllSectors(action: drawShape)
    doWithAllSectors(action: addTextLabel)
  }

  private func updateSelectedSectorBackgroundColor(index newSelectedIndex: Int) {
    let oldSelectedSectorLayer = sectorLayers[selectedIndex]
    fillColor(layer: oldSelectedSectorLayer, index: selectedIndex)

    let newSelectedSectorLayer = sectorLayers[newSelectedIndex]
    newSelectedSectorLayer.fillColor = sectorSelectedColor
    selectedIndex = newSelectedIndex
  }


  private func doWithAllSectors(action: (DCWheelSector) -> Void) {
    for sector in sectors {
      action(sector)
    }
  }

  private func drawShape(with sector: DCWheelSector) {
    let sectorLayer = CAShapeLayer()
    let path = UIBezierPath()
    path.move(to: centerPoint)
    path.addArc(withCenter: centerPoint,
                radius: radius,
                startAngle: CGFloat(sector.minValue),
                endAngle: CGFloat(sector.maxValue),
                clockwise: true)
    path.close()
    sectorLayer.path = path.cgPath

    fillColor(layer: sectorLayer, index: sector.index)
    sectorLayers.append(sectorLayer)
    layer.addSublayer(sectorLayer)
  }

  private func fillColor(layer: CAShapeLayer, index: Int) {
    let color1 = (style == .outside) ? sectorColor1 : sectorColor2
    let color2 = (style == .outside) ? sectorColor2 : sectorColor1
    layer.fillColor = (index % 2 == 0) ? color1 : color2
  }

  private func addTextLabel(with sector: DCWheelSector) {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
    label.font = UIFont.boldSystemFont(ofSize: 26)
    label.backgroundColor = UIColor.clear
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.text = "\(sector.index)"
    label.layer.anchorPoint = CGPoint(x: 0.5, y: labelAnchorPointY())
    label.layer.position = centerPoint
    label.transform = CGAffineTransform.identity
      .rotated(by: sector.labelAngle)
    addSubview(label)
  }

  private func labelAnchorPointY() -> CGFloat {
    return (style == .outside) ? 1.37 : 1.3
  }

  private func setupBorder() {
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

  func detectIndex() -> Int {
    let result = detectCurrentSector().index
    updateSelectedSectorBackgroundColor(index: result)
    return result
  }

  func detectTapIndex(point: DCPolarPoint) -> Int {
    let radians = currentRadians()
    print("Radians: \(radians)")
    let totalRadians = 2*CGFloat.pi + point.angle - radians
    let sector = sectors.filter {
      totalRadians > $0.minValue &&
        totalRadians < $0.maxValue
    }.last
    guard let result = sector else {
      print("Unknown radians: \(totalRadians)")
      return -99
    }

    print(#function, ": \(result.index)")


    print("Result: \(result.midValue)")
    let angleDifference = -(result.midValue - CGFloat.pi + radians)
    print("angleDifference = \(angleDifference)")
    UIView.animate(withDuration: 0.2) {
      self.transform = self.transform.rotated(by: angleDifference)
    }
    updateSelectedSectorBackgroundColor(index: result.index)
    return result.index
  }

  func alignmentSector() {
    let sectorDifferenceValue = currentAngleValue() - detectCurrentSector().midValue
    UIView.animate(withDuration: 0.2) {
      self.transform = self.transform.rotated(by: -sectorDifferenceValue)
    }
  }

  private func detectCurrentSector() -> DCWheelSector {
    return sectors.filter {
      currentAngleValue() > $0.minValue &&
      currentAngleValue() < $0.maxValue
      }.last ?? sectors.first!
  }

  private func currentRadians() -> CGFloat {
    return CGFloat(atan2f(Float(transform.b), Float(transform.a)))
  }
  private func currentAngleValue() -> CGFloat {

//    let convertAngle = (currentRadians() <= 0) ? CGFloat.pi : 3*CGFloat.pi
//    return convertAngle + CGFloat(currentRadians())
    return CGFloat.pi + currentRadians()
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
