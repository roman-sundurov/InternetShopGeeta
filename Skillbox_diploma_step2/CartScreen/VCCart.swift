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
    
    
    
    //MARK: - клики
    
    @IBAction func buttonCloseCartScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
        
    //MARK: - данные
    
    func updateData() {
        cartCollectionView.reloadData()
    }
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppSystemData.instance.vcCart = self
    }
    
}


//MARK: - additional protocols
extension VCCart: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Persistence.shared.getAllObjectOfCart().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var specificGood: CartGoods? = Persistence.shared.getAllObjectOfCart()[indexPath.row]
        
        var cellOfCart: CartCollectionViewCell?
        cellOfCart = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? CartCollectionViewCell
        
        cellOfCart!.layer.cornerRadius = 30
        cellOfCart!.clipsToBounds = true
        
        cellOfCart?.productImage.image = UIImage.init(data: specificGood!.goodsUIImageData as! Data)
        cellOfCart?.nameLabel.text = specificGood?.name
        cellOfCart?.priceLabel.text = String(format: "$%.2f usd", specificGood!.price)
        cellOfCart?.specificGood = specificGood
        
        if specificGood?.size?.sSize == true {
            cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
        }
        if specificGood?.size?.mSize == true {
            cellOfCart?.buttonSize.setImage(UIImage.init(named: "sSizeCart"), for: .normal)
        }

        if specificGood?.size?.lSize == true {
            cellOfCart?.buttonSize.setImage(UIImage.init(named: "lSizePainted"), for: .normal)
        }

        if specificGood?.size?.xlSize == true {
            cellOfCart?.buttonSize.setImage(UIImage.init(named: "xlSizePainted"), for: .normal)
        }

        if specificGood?.size?.xxlSize == true {
            cellOfCart?.buttonSize.setImage(UIImage.init(named: "xxlSizePainted"), for: .normal)
        }
        
        return cellOfCart!
    }
    
    
}
