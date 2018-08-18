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
    var mid: Float = 0
    for i in 0 ..< numberOfSectors {
      let sector = DCWheelSector(midValue: mid, fanWidth: fanWidth(), index: i)
      if sector.maxValue-fanWidth() < -Float.pi {
        mid = Float.pi
      }
      mid -= fanWidth()
      sectors.append(sector)
    }
  }

  private func fanWidth() -> Float {
    return Float.pi * 2 / Float(numberOfSectors)
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
    label.layer.anchorPoint = CGPoint(x: 0.5, y: labelAnchorPointY())
    label.layer.position = centerPoint
    label.transform = CGAffineTransform.identity
      .rotated(by: CGFloat(midAngle(index: index)-Float.pi/2))
    addSubview(label)
  }

  private func labelAnchorPointY() -> CGFloat {
    return (style == .outside) ? 1.37 : 1.3
  }

  private func drawSectorTextLayer(index: Int) {
    let textLayer = CATextLayer()
    textLayer.frame = CGRect(x: 0, y: 0, width: radius, height: radius)
//    textLayer.contentsScale = UIScreen.main.scale
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

  private func setupBorder() {
    borderImageView.frame = bounds
    addSubview(borderImageView)
    let image = (style == .outside) ? UIImage(named: "O_out") :
      UIImage(named: "O_middle")
    borderImageView.image = image
  }

  private var sectorDifferenceValue: CGFloat = 0
  func detectIndex() -> Int {
    var result: Float = 0
    var resultIndex = 0
    let radians = atan2f(Float(transform.b), Float(transform.a))
    for sector in sectors {
      if sector.minValue > 0 && sector.maxValue < 0 {
        if sector.maxValue > radians || sector.minValue < radians {
          if radians > 0 {
            result = radians - Float.pi
          } else {
            result = Float.pi + radians
          }
          resultIndex = sector.index
        }
      } else if radians > sector.minValue && radians < sector.maxValue {
        result = radians - sector.midValue
        resultIndex = sector.index
      }
    }
    sectorDifferenceValue = CGFloat(result)
    return resultIndex
  }

  func alignmentSector(index: Int) {
    let radians = atan2f(Float(transform.b), Float(transform.a))
    let selectedSector = sectors.filter { $0.index == index }.last
    guard let sector = selectedSector else { return }
    let result = CGFloat(radians - sector.minValue)
    print("(\(result) : \(sectorDifferenceValue))")

    UIView.animate(withDuration: 0.2) {
      self.transform = self.transform.rotated(by: -self.sectorDifferenceValue)
//      self.transform = self.transform.rotated(by: result)
    }
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
