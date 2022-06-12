//
//  VCCart.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 02.12.2021.
//

import UIKit

class VCCart: UIViewController {
  // MARK: - делегаты и переменные
  internal lazy var dataSource = makeDataSource()
  internal var sections = CatalogData.instance.getAllCatalogsAndCartGoodsDiffable()
  internal let cellPadding = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 0, right: 15.0)

  typealias DataSourceAlias = UICollectionViewDiffableDataSource<CartCategoriesAndProductsDiffable, Cart>
  typealias SnapshotAlias = NSDiffableDataSourceSnapshot<CartCategoriesAndProductsDiffable, Cart>

  @IBOutlet var cartCollectionView: UICollectionView!


// MARK: - клики
  @IBAction func buttonCloseCartScreen(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }


// MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()

    print("VCCartCollectionController_111")
    AppSystemData.instance.vcCartDelegate = self
    configureLayout()
    applySnapshot(animatingDifferences: false)
    print("VCCartCollectionController_222")
  }
}
