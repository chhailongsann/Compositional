//
//  VideoViewController.swift
//  Compositional
//
//  Created by Chhailong Sann on 22/5/26.
//
import UIKit

//class VideosViewController: UICollectionViewController {
//  // MARK: - Properties
//  private var sections = Section.allSections
//  private lazy var dataSource = makeDataSource()
//  private var searchController = UISearchController(searchResultsController: nil)
//
//  // MARK: - Value Types
//  typealias DataSource = UICollectionViewDiffableDataSource<Section, Video>
//  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Video>
//
//  // MARK: - Life Cycles
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    view.backgroundColor = .white
//    configureLayout()
//    applySnapshot(animatingDifferences: false)
//  }
//
//  // MARK: - Functions
//  func makeDataSource() -> DataSource {
//    // 1
//    let dataSource = DataSource(
//      collectionView: collectionView,
//      cellProvider: { (collectionView, indexPath, video) ->
//        UICollectionViewCell? in
//        // 2
//        let cell = collectionView.dequeueReusableCell(
//          withReuseIdentifier: "VideoCollectionViewCell",
//          for: indexPath) as? PhoneTopUpAmountCell
//
//        return cell
//    })
//    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//      guard kind == UICollectionView.elementKindSectionHeader else {
//        return nil
//      }
//      let section = self.dataSource.snapshot()
//        .sectionIdentifiers[indexPath.section]
//      let view = collectionView.dequeueReusableSupplementaryView(
//        ofKind: kind,
//        withReuseIdentifier: PageControlFooterView.reuseIdentifier,
//        for: indexPath) as? SectionHeaderReusableView
//      view?.titleLabel.text = section.title
//      return view
//    }
//    return dataSource
//  }
//
//  // 1
//  func applySnapshot(animatingDifferences: Bool = true) {
//    // 2
//    var snapshot = Snapshot()
//    // 3
//    snapshot.appendSections(sections)
//    // 4
//    sections.forEach { section in
//      snapshot.appendItems(section.videos, toSection: section)
//    }
//    // 5
//    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
//  }
//}

// MARK: - UICollectionViewDataSource Implementation
//extension VideosViewController {
//  override func collectionView(
//    _ collectionView: UICollectionView,
//    didSelectItemAt indexPath: IndexPath
//  ) {
//
//  }
//}
//
//// MARK: - Layout Handling
//extension VideosViewController {
//  private func configureLayout() {}
//
//  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//    super.viewWillTransition(to: size, with: coordinator)
//    coordinator.animate(alongsideTransition: { context in
//      self.collectionView.collectionViewLayout.invalidateLayout()
//    }, completion: nil)
//  }
//}
