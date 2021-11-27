//
//  VCCart.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 09.11.2021.
//

import UIKit

class VCCart: UIViewController {
    
    
    //MARK: - объявление аутлетов
    @IBOutlet var cartCollectionView: UICollectionView!
    
    
    //MARK: - делегаты и переменные
    
    private lazy var dataSource = makeDataSource()
    private var sections = CatalogData.instance.getAllCatalogsAndCartGoodsDiffable()
    
    typealias DataSourceAlias = UICollectionViewDiffableDataSource<CatalogsAndCartGoodsDiffable, CartGoodsDiffable>
    typealias SnapshotAlias = NSDiffableDataSourceSnapshot<CatalogsAndCartGoodsDiffable, CartGoodsDiffable>
    
    
    //MARK: - клики
    
    @IBAction func buttonCloseCartScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
        
    //MARK: - данные
    
    func updateData() {
//        CatalogData.instance.updateCatalogsAndCartGoodsDiffableArray()
//        cartCollectionView.reloadData()
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

//            if cartGoods.size?.sSize == true {
                cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
//            }
//            if good.size?.mSize == true {
//                cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
//            }
//
//            if good.size?.lSize == true {
//                cellOfCart?.buttonSize.setImage(UIImage.init(named: "lSizePainted"), for: .normal)
//            }
//
//            if good.size?.xlSize == true {
//                cellOfCart?.buttonSize.setImage(UIImage.init(named: "xlSizePainted"), for: .normal)
//            }
//
//            if good.size?.xxlSize == true {
//                cellOfCart?.buttonSize.setImage(UIImage.init(named: "xxlSizePainted"), for: .normal)
//            }
            
            return cellOfCart })
        
//              dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//                guard kind == UICollectionView.elementKindSectionHeader else {
//                  return nil
//                }
//
//                let view = collectionView.dequeueReusableSupplementaryView(
//                  ofKind: kind,
//                  withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
//                  for: indexPath) as? SectionHeaderReusableView
//                // 4
//                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
//                view?.titleLabel.text = section.title
//                return view
//              }
        
        return dataSource
        
    }
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppSystemData.instance.vcCartDelegate = self
        
        applySnapshot(animatingDifferences: false)
    }
    
}


//MARK: - additional protocols

//extension VCCart: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return Persistence.shared.getAllObjectOfCart().count
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        var specificGood: CartGoods? = Persistence.shared.getAllObjectOfCart()[indexPath.row]
//
//        var cellOfCart: CartCollectionViewCell?
//        cellOfCart = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? CartCollectionViewCell
//
//        cellOfCart!.layer.cornerRadius = 30
//        cellOfCart!.clipsToBounds = true
//
//        cellOfCart?.productImage.image = UIImage.init(data: specificGood!.goodsUIImageData as! Data)
//        cellOfCart?.nameLabel.text = specificGood?.name
//        cellOfCart?.priceLabel.text = String(format: "$%.2f usd", specificGood!.price)
//        cellOfCart?.specificGood = specificGood
//
//        if specificGood?.size?.sSize == true {
//            cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
//        }
//        if specificGood?.size?.mSize == true {
//            cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
//        }
//
//        if specificGood?.size?.lSize == true {
//            cellOfCart?.buttonSize.setImage(UIImage.init(named: "lSizePainted"), for: .normal)
//        }
//
//        if specificGood?.size?.xlSize == true {
//            cellOfCart?.buttonSize.setImage(UIImage.init(named: "xlSizePainted"), for: .normal)
//        }
//
//        if specificGood?.size?.xxlSize == true {
//            cellOfCart?.buttonSize.setImage(UIImage.init(named: "xxlSizePainted"), for: .normal)
//        }
//
//        return cellOfCart!
//    }
//
//
//}
