//
//  ViewController.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//

import UIKit
import BXAnchor

class ViewController: UIViewController {

  let dataSources: [UIImage] = [
    .unsplash01,
    .unsplash02,
    .unsplash03,
    .unsplash04,
    .unsplash05,
    .unsplash06,
    .unsplash07
  ]

  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init()).config {
    $0.alwaysBounceVertical = true
    $0.delegate = self
    $0.dataSource = self
    $0.register(CardBannerCell.self)
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
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    dataSources.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardBannerCell.identifier, for: indexPath) as! CardBannerCell
    let dataSource = self.dataSources[indexPath.item]
    cell.bind(dataSource)
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PageControlFooterView.reusableIdentifier, for: indexPath) as! PageControlFooterView
    footer.setTotalPages(dataSources.count)
    return footer
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .centeredHorizontally, animated: true)
  }
}


extension ViewController {

  func configureCompositionalLayout(){
    let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
      switch sectionIndex {
      case 0 :
        return AppLayout.shared.cardBannerSection(for: self.collectionView)
      default:
        return AppLayout.shared.cardBannerSection(for: self.collectionView)
      }
    }
//    layout.register(SectionDecorationView.self, forDecorationViewOfKind: "SectionBackground")
    collectionView.setCollectionViewLayout(layout, animated: true)
  }
}
