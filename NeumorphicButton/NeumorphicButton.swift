//
//  NeumorphicButton.swift
//  NeumorphicButton
//
//  Created by Jesse Seidman on 2/19/20.
//  Copyright © 2020 Jesse Seidman. All rights reserved.
//

import UIKit

class NeumorphicButton: UIView {
  // MARK: Public Static Properties
  static let defaultColor: UIColor = UIColor(red: 235 / 255.0, green: 236 / 255.0, blue: 240 / 255.0, alpha: 1.0)
  static let shadowLighterColor: UIColor = .white
  static let shadowDarkerColor: UIColor = UIColor(red: 166 / 255.0, green: 171 / 255.0, blue: 189 / 255.0, alpha: 1.0)

  // MARK: Public Properties
  var animationTime: TimeInterval = 0.25
  private(set) var selected: Bool = false

  // MARK: Private Properties
  private let topLeftOuterShadowLayer: CALayer = .init()
  private let bottomRightOuterShadowLayer: CALayer = .init()
  private let topLeftInnerShadowLayer: CALayer = .init()
  private let bottomRightInnerShadowLayer: CALayer = .init()
  private let cornerRadiusToHeightRatio: CGFloat
  private let shadowMultiplier: CGFloat = 0.02
  private let superviewBackgroundColor: UIColor
  private var isAnimating: Bool = false

  // MARK: Public Methods
  init(
    frame: CGRect,
    superviewBackgroundColor: UIColor = NeumorphicButton.defaultColor,
    cornerRadiusToHeightRatio: CGFloat = 0.2
  ) {
    self.superviewBackgroundColor = superviewBackgroundColor
    self.cornerRadiusToHeightRatio = cornerRadiusToHeightRatio
    super.init(frame: frame)
    self.setUpViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.frame.height * cornerRadiusToHeightRatio

    self.topLeftOuterShadowLayer.frame = self.layer.bounds
    self.bottomRightOuterShadowLayer.frame = self.layer.bounds

    self.topLeftInnerShadowLayer.frame = self.layer.bounds
    self.bottomRightInnerShadowLayer.frame = self.layer.bounds

    let path = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.frame.height * cornerRadiusToHeightRatio)
    let cutout = UIBezierPath(
      roundedRect: self.layer.bounds.insetBy(dx: -1, dy: -1),
      cornerRadius: self.frame.height * cornerRadiusToHeightRatio
    ).reversing()
    path.append(cutout)

    self.topLeftInnerShadowLayer.shadowPath = path.cgPath
    self.bottomRightInnerShadowLayer.shadowPath = path.cgPath
  }

  @objc func tapped() {
    guard !self.isAnimating else { return }

    DispatchQueue.main.async {
      let outerShadowStart: CGFloat = self.selected ? 0 : 1
      let outerShadowEnd: CGFloat = outerShadowStart == 0 ? 1 : 0

      let innerShadowStart: CGFloat = self.selected ? 1 : 0
      let innerShadowEnd: CGFloat = innerShadowStart == 0 ? 1 : 0

      let dispatchGroup = DispatchGroup()

      self.isAnimating = true

      dispatchGroup.enter()
      self.animateLayerOpacity(on: self.topLeftOuterShadowLayer, from: outerShadowStart, to: outerShadowEnd, duration: self.animationTime, completion: { dispatchGroup.leave() })

      dispatchGroup.enter()
      self.animateLayerOpacity(on: self.topLeftInnerShadowLayer, from: innerShadowStart, to: innerShadowEnd, duration: self.animationTime, completion: { dispatchGroup.leave() })

      dispatchGroup.enter()
      self.animateLayerOpacity(on: self.bottomRightOuterShadowLayer, from: outerShadowStart, to: outerShadowEnd, duration: self.animationTime, completion: { dispatchGroup.leave() })

      dispatchGroup.enter()
      self.animateLayerOpacity(on: self.bottomRightInnerShadowLayer, from: innerShadowStart, to: innerShadowEnd, duration: self.animationTime, completion: { dispatchGroup.leave() })

      dispatchGroup.notify(queue: .main) {
        self.isAnimating = false
        self.selected.toggle()
      }
    }
  }

  // MARK: Private Methods
  private func setUpViews() {
    self.clipsToBounds = false
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    setUpTopLeftOuterShadowLayer()
    setUpBottomRightOuterShadowLayer()
    setUpTopLeftInnerShadowLayer()
    setUpBottomRightInnerShadowLayer()
  }

  private func configureShadow(
    on layer: CALayer,
    backgroundColor: CGColor?,
    masksToBounds: Bool,
    cornerRadius: CGFloat,
    shadowColor: CGColor,
    shadowRadius: CGFloat,
    shadowOffset: CGSize,
    shadowOpacity: Float,
    opacity: Float
  ) {
    if let backgroundColor = backgroundColor {
      layer.backgroundColor = backgroundColor
    }
    layer.masksToBounds = masksToBounds
    layer.cornerRadius = cornerRadius
    layer.shadowColor = shadowColor
    layer.shadowRadius = shadowRadius
    layer.shadowOffset = shadowOffset
    layer.shadowOpacity = shadowOpacity
    layer.opacity = opacity
  }

  private func setUpTopLeftOuterShadowLayer() {
    self.configureShadow(
      on: topLeftOuterShadowLayer,
      backgroundColor: self.superviewBackgroundColor.cgColor,
      masksToBounds: false,
      cornerRadius: self.frame.height * cornerRadiusToHeightRatio,
      shadowColor: NeumorphicButton.shadowLighterColor.cgColor,
      shadowRadius: self.frame.height * shadowMultiplier,
      shadowOffset: CGSize(width: -self.frame.height * shadowMultiplier, height: -self.frame.height * shadowMultiplier),
      shadowOpacity: 1.0,
      opacity: 1.0
    )

    self.layer.addSublayer(topLeftOuterShadowLayer)
  }

  private func setUpBottomRightOuterShadowLayer() {
    self.configureShadow(
      on: bottomRightOuterShadowLayer,
      backgroundColor: self.superviewBackgroundColor.cgColor,
      masksToBounds: false,
      cornerRadius: self.frame.height * cornerRadiusToHeightRatio,
      shadowColor: NeumorphicButton.shadowDarkerColor.cgColor,
      shadowRadius: self.frame.height * shadowMultiplier,
      shadowOffset: CGSize(width: self.frame.height * shadowMultiplier, height: self.frame.height * shadowMultiplier),
      shadowOpacity: 1.0,
      opacity: 1.0
    )

    self.layer.addSublayer(bottomRightOuterShadowLayer)
  }

  private func setUpTopLeftInnerShadowLayer() {
    self.configureShadow(
      on: topLeftInnerShadowLayer,
      backgroundColor: nil,
      masksToBounds: true,
      cornerRadius: self.frame.height * cornerRadiusToHeightRatio,
      shadowColor: NeumorphicButton.shadowDarkerColor.cgColor,
      shadowRadius: self.frame.height * shadowMultiplier,
      shadowOffset: CGSize(width: self.frame.height * shadowMultiplier, height: self.frame.height * shadowMultiplier),
      shadowOpacity: 1.0,
      opacity: 0
    )

    self.layer.insertSublayer(topLeftInnerShadowLayer, at: 0)
  }

  private func setUpBottomRightInnerShadowLayer() {
    self.configureShadow(
      on: bottomRightInnerShadowLayer,
      backgroundColor: nil,
      masksToBounds: true,
      cornerRadius: self.frame.height * cornerRadiusToHeightRatio,
      shadowColor: NeumorphicButton.shadowLighterColor.cgColor,
      shadowRadius: self.frame.height * shadowMultiplier,
      shadowOffset: CGSize(width: -self.frame.height * shadowMultiplier, height: -self.frame.height * shadowMultiplier),
      shadowOpacity: 1.0,
      opacity: 0
    )

    self.layer.insertSublayer(bottomRightInnerShadowLayer, at: 0)
  }

  private func animateLayerOpacity(
    on animatingLayer: CALayer,
    from: CGFloat,
    to: CGFloat,
    duration: TimeInterval,
    completion: @escaping () -> Void
  ) {
    CATransaction.begin()

    let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
    animation.fromValue = NSNumber(floatLiteral: Double(from))
    animation.toValue = NSNumber(floatLiteral: Double(to))
    animation.duration = duration
    animatingLayer.opacity = Float(to)

    CATransaction.setCompletionBlock(completion)
    animatingLayer.add(animation, forKey: animation.keyPath)
    CATransaction.commit()
  }
}
