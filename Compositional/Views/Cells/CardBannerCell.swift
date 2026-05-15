//
//  CardBannerCell.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//

import UIKit
import BXAnchor

final class CardBannerCell: UICollectionViewCell {

  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  func bind(_ image: UIImage) {
    self.imageView.image = image
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setUpViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setUpViews() {
    imageView.layout(in: self.contentView) {
      $0.fill()
    }
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 12
  }
}


extension UICollectionViewCell {
  static var identifier: String {
    return String(describing: self)
  }
}


extension UICollectionView {
  final func register<T: UICollectionViewCell>(_ T: T.Type) {
    register(T.self, forCellWithReuseIdentifier: T.identifier)
  }
  func registerSupplementaryView<T: UICollectionReusableView>(_: T.Type, for kind: String) {
    register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reusableIdentifier)
  }

}

extension UICollectionReusableView {
  static var reusableIdentifier: String {
    return String(describing: self)
  }
}
