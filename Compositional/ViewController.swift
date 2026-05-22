//
//  ViewController.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//

import UIKit
import BXAnchor

@MainActor
class ViewController: UIViewController {

  let images: [UIImage] = [
    .unsplash01,
    .unsplash02,
    .unsplash03,
    .unsplash04,
    .unsplash05,
    .unsplash06,
    .unsplash07,
    .unsplash01,
    .unsplash02,
    .unsplash03,
    .unsplash04,
    .unsplash05,
    .unsplash06,
    .unsplash07,
    .unsplash01,
    .unsplash02,
    .unsplash03,
    .unsplash04,
    .unsplash05,
    .unsplash06,
    .unsplash07
  ]
  let items: [Int] = [
    1,
    2,
    5,
    10,
    15,
    20,
    30,
    40,
    50,
    100
  ]

  struct Item: Hashable, Identifiable {
    var id: UUID
    var image: UIImage
  }

  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init()).config {
    let layout = UICollectionViewFlowLayout()
    $0.alwaysBounceVertical = true
    $0.delegate = self
    $0.register(CardBannerCell.self)
    $0.register(PhoneTopUpAmountCell.self)
    $0.registerSupplementaryView(PageControlFooterView.self, for: UICollectionView.elementKindSectionFooter)
    $0.backgroundColor = .systemBackground
  }

  override func loadView() {
    super.loadView()
    collectionView.layout(in: view) {
      $0.fill(ignoreSafeArea: true)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "Images"
    view.backgroundColor = .systemBackground
    configureCompositionalLayout()
    collectionView.dataSource = self
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    ViewSection.allCases.count
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let section = ViewSection.init(rawValue: section) else {
      fatalError("Invalid section")
    }

    switch section {
    case .cardBanner:
      return images.count
    case .phoneTopUp:
      return items.count
    case .serviceCategory:
      return items.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let section = ViewSection.init(rawValue: indexPath.section) else {
      fatalError("Invalid section")
    }

    let cell: UICollectionViewCell
    switch section {
    case .cardBanner:
      let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardBannerCell.identifier, for: indexPath) as! CardBannerCell
      let dataSource = self.images[indexPath.item]
      imageCell.bind(dataSource)
      cell = imageCell
    case .phoneTopUp:
      let phoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhoneTopUpAmountCell.identifier, for: indexPath) as! PhoneTopUpAmountCell
      phoneCell.bind(items[indexPath.item])
      cell = phoneCell
    case .serviceCategory:
      let phoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhoneTopUpAmountCell.identifier, for: indexPath) as! PhoneTopUpAmountCell
      phoneCell.bind(items[indexPath.item])
      cell = phoneCell    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let section = ViewSection(rawValue: indexPath.section) else {
      fatalError("Invalid Section")
    }
    let footer: UICollectionReusableView
    switch section {
    case .cardBanner:
      let pageControlFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PageControlFooterView.reusableIdentifier, for: indexPath) as! PageControlFooterView
      pageControlFooterView.setTotalPages(images.count)
      footer = pageControlFooterView
    case .phoneTopUp:
      footer = UICollectionReusableView()

    case .serviceCategory:
      footer = UICollectionReusableView()

    }
    return footer
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
  }
}


extension ViewController {

  func configureCompositionalLayout(){
    let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
      guard let section = ViewSection(rawValue: sectionIndex) else {
        fatalError("Invalid section")
      }
      switch section {
      case .cardBanner :
        return AppLayout.shared.cardBannerSection(for: self.collectionView)
      case .phoneTopUp:
        return AppLayout.shared.verticalGrid(3)
      case .serviceCategory:
        return AppLayout.shared.horizontalGrid(3)
      }
    }
    layout.register(SectionDecorationView.self, forDecorationViewOfKind: "SectionBackground")
    collectionView.setCollectionViewLayout(layout, animated: true)
  }
}
