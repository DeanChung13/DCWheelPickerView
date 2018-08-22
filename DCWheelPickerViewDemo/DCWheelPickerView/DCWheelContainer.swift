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
  lazy var fanWidth: CGFloat = {
    return CGFloat.pi * 2 / CGFloat(numberOfSectors)
  }()
  private var style: WheelContainerStyle
  private var sectorLayers: [CAShapeLayer] = []

  let sectorColor1 = UIColor(rgbHex: 0x59636F).cgColor
  let sectorColor2 = UIColor(rgbHex: 0x90A6BC).cgColor
  let sectorSelectedColor = UIColor(rgbHex: 0x55BFE7).cgColor
  private var prepareChangeToSector: DCWheelSector?

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
      let sector = DCWheelSector(index: i, fanWidth: fanWidth)
      mid += fanWidth
      sectors.append(sector)
      print(sector)
    }
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
                startAngle: CGFloat(sector.arcStartAngle),
                endAngle: CGFloat(sector.arcEndAngle),
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
    let sector = detectCurrentSector()
    let result = sector.index
    prepareChangeToSector = sector
    return result
  }

  func detectTapIndex(point: DCPolarPoint) -> Int {
    var totalRadians = point.radians + rotatedRadians()
    if totalRadians > CGFloat.pi {
      totalRadians = -2*CGFloat.pi + totalRadians
    }
    if totalRadians < -CGFloat.pi {
      totalRadians = 2*CGFloat.pi + totalRadians
    }

    guard let sector = detectSector(sectorRadians: totalRadians) else {
      print("Unknown radians: \(totalRadians)")
      return -99
    }
    let result = sector.index
    print(#function, ": \(result)")
    prepareChangeToSector = sector
    return result
  }

  func alignmentToNewSector() {
    guard let sector = prepareChangeToSector else { return }
    let sectorDifferenceValue = sectorDifferenceRadians(from: sector.midValue)
    UIView.animate(withDuration: 0.2) {
      self.transform = CGAffineTransform.identity.rotated(by: sectorDifferenceValue)
    }
    prepareChangeToSector = nil
    updateSelectedSectorBackgroundColor(index: sector.index)
  }

  private func detectCurrentSector() -> DCWheelSector {
    let currentSectorRadians = rotatedSectorRadians()
    return detectSector(sectorRadians: currentSectorRadians) ?? sectors.first!
  }

  private func detectSector(sectorRadians: CGFloat) -> DCWheelSector? {
    return sectors.filter {
      var result = false
      var minValue = $0.minValue
      var maxValue = $0.maxValue
      if maxValue < minValue {
        if sectorRadians < 0 {
          minValue = -CGFloat.pi - ($0.midValue - $0.minValue)
        } else {
          maxValue = CGFloat.pi + ($0.midValue - $0.minValue)
        }
      }
      result = sectorRadians > minValue && sectorRadians < maxValue
      return result
      }.last
  }

  private func rotatedRadians() -> CGFloat {
    return CGFloat(atan2f(Float(transform.b), Float(transform.a)))
  }

  private func rotatedSectorRadians() -> CGFloat {
    return sectorDifferenceRadians(from: rotatedRadians())
  }

  private func sectorDifferenceRadians(from radians: CGFloat) -> CGFloat {
    let result: CGFloat
    if radians >= 0 {
      result = radians - CGFloat.pi
    } else {
      result = radians + CGFloat.pi
    }
    return result
  }

}
