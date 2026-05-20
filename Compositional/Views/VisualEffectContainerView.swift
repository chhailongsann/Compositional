//
//  VisualEffectContainerView.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//

import UIKit
import BXAnchor

class VisualEffectContainerView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    let effect: UIVisualEffect
    if #available(iOS 26.0, *) {
      effect = UIBlurEffect(style: .regular)
    } else {
      effect = UIBlurEffect(style: .regular)
    }
    backgroundColor = .black.withAlphaComponent(0.1)
    let visualEffectView = UIVisualEffectView(effect: effect)
    visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    clipsToBounds = true
    layer.cornerRadius = frame.height / 2

    visualEffectView.layout(in: self) {
      $0.fill()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

