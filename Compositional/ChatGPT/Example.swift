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
    case horizontalGrid
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
        return AppLayout.shared.cardBannerSection(for: self.collectionView)

      case .horizontalGrid:
        return self.makeHorizontalGridSection()

      case .grid:
        return self.makeColumnLayout()
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

    let itemHeight: CGFloat = 40
    let spacing: CGFloat = 16
    // Item
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(itemHeight)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    // Vertical group = 3 rows
    let columnGroupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1/3),
        heightDimension: .absolute(CGFloat(numberOfColumns) * itemHeight + CGFloat(numberOfColumns - 1) * spacing)
    )

    let columnGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: columnGroupSize,
        subitem: item,
        count: numberOfColumns
    )

    columnGroup.interItemSpacing = .fixed(spacing)

    // Section
    let section = NSCollectionLayoutSection(group: columnGroup)

    section.orthogonalScrollingBehavior = .continuous

    section.interGroupSpacing = spacing

    section.contentInsets = NSDirectionalEdgeInsets(
        top: 0,
        leading: spacing,
        bottom: 20,
        trailing: spacing
    )

    return section
}

  func makeColumnLayout() -> NSCollectionLayoutSection {
    
    // Item takes full width of its group column
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(50)
    )
    let padding: CGFloat = 16

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

    case .horizontalGrid:
      return 10

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
    } else if indexPath.section == 1 {
      cell.backgroundColor = .systemOrange
    } else {
      cell.backgroundColor = .systemIndigo
    }

    cell.layer.cornerRadius = 12

    return cell
  }
}
