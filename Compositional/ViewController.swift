//
//  ViewController.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//

import UIKit
import BXAnchor

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
  let amounts: [Int] = [
    1,
    2,
    5,
    10,
    15,
    20,
    30,
    40,
    50,
    100,
    200,
    500,
    1,
    2,
    5,
    10,
    15,
    20,
    30,
    40,
    50,
    100,
    200,
    500,
    1,
    2,
    5,
    10,
    15,
    20,
    30,
    40,
    50,
    100,
    200,
    500
  ]

  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init()).config {
    let layout = UICollectionViewFlowLayout()
    $0.alwaysBounceVertical = true
    $0.delegate = self
    $0.dataSource = self
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
  
  }
  @objc func gotoEnd() {
    let lastIndex = collectionView.numberOfItems(inSection: 0) - 1
    collectionView.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .centeredHorizontally, animated: true)
  }
  @objc func gotoBeginning() {
    collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    2
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0:
      return images.count
    case 1:
      return amounts.count
    default :
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: UICollectionViewCell
    switch indexPath.section {
    case 0:
      let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: CardBannerCell.identifier, for: indexPath) as! CardBannerCell
      let dataSource = self.images[indexPath.item]
      imageCell.bind(dataSource)
      cell = imageCell
    case 1:
      let phoneCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhoneTopUpAmountCell.identifier, for: indexPath) as! PhoneTopUpAmountCell
      phoneCell.bind(amounts[indexPath.item])
      cell = phoneCell
    default:
      cell = UICollectionViewCell()
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer: UICollectionReusableView
    if indexPath.section == 0 {
      let pageControlFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PageControlFooterView.reusableIdentifier, for: indexPath) as! PageControlFooterView
      pageControlFooterView.setTotalPages(images.count)
      footer = pageControlFooterView
    } else {
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
      switch sectionIndex {
      case 0 :
        return AppLayout.shared.cardBannerSection(for: self.collectionView)
      case 1:
        return AppLayout.shared.phoneTopAmountSection(for: self.collectionView)
      default:
        return AppLayout.shared.cardBannerSection(for: self.collectionView)
      }
    }
    //    layout.register(SectionDecorationView.self, forDecorationViewOfKind: "SectionBackground")
    collectionView.setCollectionViewLayout(layout, animated: true)
  }
}
