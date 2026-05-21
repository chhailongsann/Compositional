//
//  PhoneTopUpAmountCell.swift
//  Compositional
//
//  Created by Chhailong Sann on 21/5/26.
//

import UIKit
import BXAnchor

final class PhoneTopUpAmountCell: UICollectionViewCell {

  private lazy var label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    return label
  }()

  func bind(_ amount: Int) {
    self.label.text = "$\(amount)"
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setUpViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpViews() {
    label.layout(in: self.contentView) {
      $0.fill()
    }
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 8
    contentView.backgroundColor = .secondarySystemBackground
  }
}
