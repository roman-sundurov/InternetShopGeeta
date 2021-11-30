//
//  VCCartCollectionController.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 30.11.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class VCCartCollectionController: UICollectionViewController {
    
    //MARK: - объявление аутлетов
    @IBOutlet var cartCollectionView: UICollectionView!
    
    
    //MARK: - делегаты и переменные
    
    private lazy var dataSource = makeDataSource()
    private var sections = CatalogData.instance.getAllCatalogsAndCartGoodsDiffable()
    
    typealias DataSourceAlias = UICollectionViewDiffableDataSource<CatalogsAndCartGoodsDiffable, CartGoodsDiffable>
    typealias SnapshotAlias = NSDiffableDataSourceSnapshot<CatalogsAndCartGoodsDiffable, CartGoodsDiffable>
    
    private let cellPadding = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 0, right: 15.0)
    
    
    //MARK: - клики
    
    @IBAction func buttonCloseCartScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    //MARK: - данные
    
    func updateData() {
        sections = CatalogData.instance.getAllCatalogsAndCartGoodsDiffable()
        applySnapshot()
    }
    
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = SnapshotAlias()
//      snapshot.appendSections([.main])
//      snapshot.appendItems(videoList)
        snapshot.appendSections(sections)
        sections.forEach { section in snapshot.appendItems(section.cartGoodsDiffable, toSection: section) }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    
    func makeDataSource() -> DataSourceAlias {
        print("0000")
        let dataSource = DataSourceAlias(collectionView: cartCollectionView, cellProvider: { (collectionView, indexPath, cartGoodsDiffable) -> UICollectionViewCell? in
            
            print("0111")
            let cellOfCart = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? CartCollectionViewCell
            print("0222")
            cellOfCart!.layer.cornerRadius = 30
            cellOfCart!.clipsToBounds = true
            print("0333")
            cellOfCart!.productImage.image = UIImage.init(data: cartGoodsDiffable.goodsUIImageData as! Data)
            cellOfCart!.nameLabel.text = cartGoodsDiffable.name
            cellOfCart!.priceLabel.text = String(format: "$%.2f usd", cartGoodsDiffable.price)
            cellOfCart!.specificGood = cartGoodsDiffable

            if cartGoodsDiffable.size.sSize == true {
                cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
            }
            if cartGoodsDiffable.size.mSize == true {
                cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
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
            
            return cellOfCart })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
        guard kind == UICollectionView.elementKindSectionHeader else {
            return nil
        }

        let view = collectionView.dequeueReusableSupplementaryView( ofKind: kind, withReuseIdentifier: CartCollectionHeaderReusableView.reuseIdentifier, for: indexPath) as? CartCollectionHeaderReusableView
        // 4
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.titleLabel.text = section.category
        return view
        }
        
        return dataSource
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        AppSystemData.instance.vcCartDelegate = self
        applySnapshot(animatingDifferences: false)
    }
    
}
    

// MARK: UICollectionViewDataSource
    
    
extension VCCartCollectionController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return cellPadding
    }

}

    
//override func numberOfSections(in collectionView: UICollectionView) -> Int {
//    // #warning Incomplete implementation, return the number of sections
//    return 0
//}
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        // Configure the cell
//        return cell
//    }


// MARK: - Layout Handling
extension VCCartCollectionController {
    
  private func configureLayout() { collectionView.register(
    CartCollectionHeaderReusableView.self,
    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
    withReuseIdentifier: CartCollectionHeaderReusableView.reuseIdentifier
  )

    
    collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
      let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
      let size = NSCollectionLayoutSize(
        widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
        heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
      )
      let itemCount = isPhone ? 1 : 3
      let item = NSCollectionLayoutItem(layoutSize: size)
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      
        // Supplementary header view setup
        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
      
      return section
    })
  }

}
