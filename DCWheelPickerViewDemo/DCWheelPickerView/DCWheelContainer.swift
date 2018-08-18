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
    return frame.size.width / 2.0 - 10.0
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

  private let borderImageView = UIImageView()

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
      let sector = DCWheelSector(midValue: mid, fanWidth: fanWidth(), index: i)
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
//    doWithAllSectors(drawSectorTextLayer)
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

  private func drawTextLayer(with sector: DCWheelSector) {
    let textLayer = CATextLayer()
    textLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
//    textLayer.contentsScale = UIScreen.main.scale
    textLayer.font = UIFont.boldSystemFont(ofSize: 26)
    textLayer.backgroundColor = UIColor.clear.cgColor
    textLayer.foregroundColor = UIColor.white.cgColor
    textLayer.alignmentMode = .center
    textLayer.string = "\(sector.index)"
    textLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
    textLayer.position = centerPoint
    textLayer.setAffineTransform(CGAffineTransform.identity
      .rotated(by: sector.labelAngle))
    layer.addSublayer(textLayer)
  }

  private func setupBorder() {
    borderImageView.frame = bounds
    addSubview(borderImageView)
    let image = (style == .outside) ? UIImage(named: "O_out") :
      UIImage(named: "O_middle")
    borderImageView.image = image
  }

  private var sectorDifferenceValue: CGFloat = 0

  func detectIndex() -> Int {
    let result = detectCurrentSector().index
    updateSelectedSectorBackgroundColor(index: result)
    return result
  }

  func alignmentSector() {
    let sectorDifferenceValue = currentSectorValue() - detectCurrentSector().midValue
    UIView.animate(withDuration: 0.2) {
      self.transform = self.transform.rotated(by: sectorDifferenceValue)
    }
  }

  private func detectCurrentSector() -> DCWheelSector {
    return sectors.filter {
      currentSectorValue() > $0.minValue &&
      currentSectorValue() < $0.maxValue
      }.last ?? sectors.first!
  }

  private func currentSectorValue() -> CGFloat {
    let radians = atan2f(Float(transform.b), Float(transform.a))
    let convertAngle = (radians <= 0) ? CGFloat.pi : 3*CGFloat.pi
    return convertAngle - CGFloat(radians)
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
