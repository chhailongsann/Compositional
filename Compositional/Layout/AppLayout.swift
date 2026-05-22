//
//  AppLayout.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//

import UIKit
import AudioToolbox

let CARD_ASPECT_RATIO: CGFloat = 10/16
let PADDING: CGFloat = 16

final class AppLayout {
  static let shared = AppLayout()


  var selectedIndex: Int?
  func cardBannerSection(for collectionView: UICollectionView)-> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalWidth(0.8 * CARD_ASPECT_RATIO))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
    section.orthogonalScrollingBehavior = .groupPagingCentered
    section.interGroupSpacing = 16

    //         PLay with some animation and scrollOffset
    section.visibleItemsInvalidationHandler = { [weak self] (items, offset, environment) in
      guard let self else { return }

      let containerWidth = environment.container.contentSize.width

      let centerX = offset.x + (containerWidth / 2)

      let closestItem = items.min {
        abs($0.frame.midX - centerX) <
          abs($1.frame.midX - centerX)
      }

      guard let indexPath = closestItem?.indexPath else {
        return
      }

      guard selectedIndex != indexPath.item else {
        return
      }
      selectedIndex = indexPath.item
      section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

      if let footer = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: .init(item: 0, section: 0)) as? PageControlFooterView {
        footer.setPage(indexPath.item)
        Haptic.selection.generate()
        AudioServicesPlaySystemSound(1157)
      }
    }
    section.boundarySupplementaryItems = [
      .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
    ]

    return section
  }

  func verticalGrid(_ numberOfColumns: Int) -> NSCollectionLayoutSection {

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

    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: item,
      count: numberOfColumns
    )

//    group.interItemSpacing = .fixed(padding)
    group.interItemSpacing = .flexible(PADDING)

    // Section
    let section = NSCollectionLayoutSection(group: group)

    section.interGroupSpacing = PADDING

    section.contentInsets = NSDirectionalEdgeInsets(
      top: 0,
      leading: PADDING,
      bottom: 0,
      trailing: PADDING
    )

    return section
  }

  func horizontalGrid(_ numberOfRows: Int) -> NSCollectionLayoutSection {

    let itemHeight: CGFloat = 40
    let spacing: CGFloat = 16
    // Item
    let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(itemHeight)
    )

    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let columnGroupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1/3),
        heightDimension: .absolute(CGFloat(numberOfRows) * itemHeight + CGFloat(numberOfRows - 1) * spacing)
    )

    let columnGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: columnGroupSize,
        subitem: item,
        count: numberOfRows
    )

    columnGroup.interItemSpacing = .fixed(PADDING)

    // Section
    let section = NSCollectionLayoutSection(group: columnGroup)

    section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

    section.interGroupSpacing = spacing

    section.contentInsets = NSDirectionalEdgeInsets(
        top: PADDING,
        leading: PADDING,
        bottom: PADDING,
        trailing: PADDING
    )

    return section
}
}

final class CardBannerCollectionLayoutSection: NSCollectionLayoutSection {

}
