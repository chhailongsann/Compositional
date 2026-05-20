//
//  AppLayout.swift
//  Compositional
//
//  Created by Chhailong Sann on 15/5/26.
//

import UIKit
import AudioToolbox

let CARD_ASPECT_RATIO: CGFloat = 10/16

final class AppLayout {
  static let shared = AppLayout()


  var selectedIndex: Int?
  func cardBannerSection(for collectionView: UICollectionView)-> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalWidth(0.8 * CARD_ASPECT_RATIO))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
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
      section.orthogonalScrollingBehavior = selectedIndex == 0 ? .continuousGroupLeadingBoundary : .groupPagingCentered

      if let footer = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: .init(item: 0, section: 0)) as? PageControlFooterView {
        footer.setPage(indexPath.item)
        Haptic.selection.generate()
        AudioServicesPlaySystemSound(1157)
      }



//      items.forEach { item in
//        let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
//        let minScale: CGFloat = 1
//        let maxScale: CGFloat = 1.0
//        let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
//        item.transform = CGAffineTransform(scaleX: scale, y: scale)
//      }

    }
    section.boundarySupplementaryItems = [
      .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
    ]



    return section
  }
}

final class CardBannerCollectionLayoutSection: NSCollectionLayoutSection {

}
