//
//  VCCartViewModel.swift
//  SkillboxDiplomaStep2
//
//  Created by Roman on 11.06.2022.
//

import Foundation
import UIKit

// MARK: - данные
extension VCCart {
  func updateData() {
    sections = CatalogData.instance.getAllCatalogsAndCartGoodsDiffable()
    applySnapshot()
  }

  func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = SnapshotAlias()
    snapshot.appendSections(sections)
    sections.forEach { section in snapshot.appendItems(section.cartGoodsDiffable, toSection: section) }
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }

  func makeDataSource() -> DataSourceAlias {
    print("0000")
    let dataSource = DataSourceAlias(collectionView: cartCollectionView) { (collectionView, indexPath, cartGoodsDiffable) -> UICollectionViewCell? in
      print("0111")
      let cellOfCart = collectionView.dequeueReusableCell(
        withReuseIdentifier: "productCell",
        for: indexPath) as? CartCollectionViewCell
      print("0222")
      cellOfCart?.layer.cornerRadius = 30
      cellOfCart?.clipsToBounds = true
      print("0333")
      cellOfCart?.productImage.image = UIImage.init(data: cartGoodsDiffable.goodsUIImageData as! Data)
      cellOfCart?.nameLabel.text = cartGoodsDiffable.name
      cellOfCart?.priceLabel.text = String(format: "$%.2f usd", cartGoodsDiffable.price)
      cellOfCart?.specificGood = cartGoodsDiffable
      if cartGoodsDiffable.size.sSize == true {
        cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
      }
      if cartGoodsDiffable.size.mSize == true {
        cellOfCart?.buttonSize.setImage(UIImage.init(named: "mSizeCart"), for: .normal)
      }
      if cartGoodsDiffable.size.lSize == true {
        cellOfCart?.buttonSize.setImage(UIImage.init(named: "lSizePainted"), for: .normal)
      }
      if cartGoodsDiffable.size.xlSize == true {
        cellOfCart?.buttonSize.setImage(UIImage.init(named: "xlSizePainted"), for: .normal)
      }
      if cartGoodsDiffable.size.xxlSize == true {
        cellOfCart?.buttonSize.setImage(UIImage.init(named: "xxlSizePainted"), for: .normal)
      }
      return cellOfCart
    }

    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
    guard kind == UICollectionView.elementKindSectionHeader else {
      return nil
    }

    let view = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: CartCollectionHeaderReusableView.reuseIdentifier,
      for: indexPath) as? CartCollectionHeaderReusableView
      let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
      view?.titleLabel.text = section.category
      print("section.category= \(section.category)")
      return view
    }
    return dataSource
  }
}


// MARK: - extension UICollectionViewDelegateFlowLayout
extension VCCart: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return cellPadding
  }
}


// MARK: - Layout Handling
extension VCCart {
  internal func configureLayout() {
    cartCollectionView.register(
      CartCollectionHeaderReusableView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: CartCollectionHeaderReusableView.reuseIdentifier
    )

    cartCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout() { _, layoutEnvironment -> NSCollectionLayoutSection? in
      let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
      let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
        heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 140 : 110)
        )
      let itemCount = isPhone ? 1 : 3
      let item = NSCollectionLayoutItem(layoutSize: size)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10

      // Supplementary header view setup
      let headerFooterSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(20)
      )
      let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: headerFooterSize,
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
      section.boundarySupplementaryItems = [sectionHeader]
      return section
    }
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
      coordinator.animate(alongsideTransition: { _ in
        self.cartCollectionView.collectionViewLayout.invalidateLayout()
    }, completion: nil)
  }
}
