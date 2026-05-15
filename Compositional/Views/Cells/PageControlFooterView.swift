//
//  PageControlFooterView.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//
import UIKit
import BXAnchor

final class PageControlFooterView: UICollectionReusableView {

  private lazy var pageControl = BXPageControl.default
  override init(frame: CGRect) {
    super.init(frame: frame)
    pageControl.layout(in: self) {
      $0.leading()
        .trailing()
        .centerY()
    }
  }

  func setTotalPages(_ totalPages: Int) {
    pageControl.setNumberOfPages(totalPages)
  }

  func setPage(_ page: Int) {
    pageControl.setCurrentPage(page)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
