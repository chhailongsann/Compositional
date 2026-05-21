//
//  Example.swift
//  Compositional
//
//  Created by Chhailong Sann on 21/5/26.
//

import UIKit
import BXAnchor

final class ExampleViewController: UIViewController {

  enum Section: Int, CaseIterable {
    case carousel
    case grid
  }
  
  private var numberOfColumns: Int = 2

  private lazy var collectionView: UICollectionView = {
    let layout = createLayout()

    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )

    collectionView.backgroundColor = .systemBackground
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    collectionView.register(
      UICollectionViewCell.self,
      forCellWithReuseIdentifier: "cell"
    )

    collectionView.dataSource = self

    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    collectionView.layout(in: self.view) {
      $0.fill(ignoreSafeArea: true)
    }
    navigationItem.rightBarButtonItems = [
      .init(image: UIImage(systemName: "square.grid.2x2.fill"), style: .plain, target: self, action: #selector(make2ColumnGrid)),
      .init(image: UIImage(systemName: "square.grid.3x2.fill"), style: .plain, target: self, action: #selector(make3ColumnGrid))
    ]
  }
  @objc func make3ColumnGrid() {
    if numberOfColumns != 3 {
      numberOfColumns = 3
      let layout = createLayout()
      collectionView.setCollectionViewLayout(layout, animated: true)
    }
  }
  @objc func make2ColumnGrid() {
    if numberOfColumns != 2 {
      numberOfColumns = 2
      let layout = createLayout()
      collectionView.setCollectionViewLayout(layout, animated: true)
    }
  }
}

// MARK: - Layout

private extension ExampleViewController {

  func createLayout() -> UICollectionViewCompositionalLayout {

    UICollectionViewCompositionalLayout { sectionIndex, environment in

      guard let section = Section(rawValue: sectionIndex) else {
        return nil
      }

      switch section {

      case .carousel:
        return self.makeCarouselSection()

      case .grid:
        return self.makeColumnLayout(self.numberOfColumns)
      }
    }
  }

  // MARK: Carousel

  func makeCarouselSection() -> NSCollectionLayoutSection {

    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    item.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 8,
      bottom: 0,
      trailing: 8
    )

    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(0.85),
      heightDimension: .absolute(220)
    )

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )

    // Section
    let section = NSCollectionLayoutSection(group: group)

    section.orthogonalScrollingBehavior = .groupPagingCentered

    section.contentInsets = NSDirectionalEdgeInsets(
      top: 16,
      leading: 0,
      bottom: 32,
      trailing: 0
    )

    return section
  }

  // MARK: Horizontal Grid

  func makeHorizontalGridSection() -> NSCollectionLayoutSection {

    // Single item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(40)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    item.contentInsets = NSDirectionalEdgeInsets(
      top: 4,
      leading: 8,
      bottom: 4,
      trailing: 8
    )

    // Vertical group (4 rows)
    let verticalGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0 / 3.0),
      heightDimension: .estimated(160)
    )

    let verticalGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: verticalGroupSize,
      subitem: item,
      count: 3
    )

    // Container group
    let containerGroupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(160)
    )

    let containerGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: containerGroupSize,
      subitems: [verticalGroup]
    )

    // Section
    let section = NSCollectionLayoutSection(group: containerGroup)

    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.interGroupSpacing = 0
    section.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: 0,
      bottom: 0,
      trailing: 0
    )

    return section
  }
  
  func makeColumnLayout(_ numberOfColumns: Int) -> NSCollectionLayoutSection {
    
    // Item takes full width of its group column
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Column group (1/3 width each)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(50)
    )
    let padding: CGFloat = 16
    // 3 items per row = 3 columns
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: numberOfColumns
    )
    
//    group.interItemSpacing = .fixed(padding)
    group.interItemSpacing = .flexible(padding)
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    
    section.interGroupSpacing = padding
    
    section.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: padding,
      bottom: 0,
      trailing: padding
    )
    
    return section
  }
}

// MARK: - Data Source

extension ExampleViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    Section.allCases.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {

    switch Section(rawValue: section)! {

    case .carousel:
      return 5

    case .grid:
      return 40
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "cell",
      for: indexPath
    )

    // Demo colors
    if indexPath.section == 0 {
      cell.backgroundColor = .systemBlue
    } else {
      cell.backgroundColor = .systemOrange
    }

    cell.layer.cornerRadius = 12

    return cell
  }
}
