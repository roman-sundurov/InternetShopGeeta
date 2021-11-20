//
//  catalogGoodsCollectionViewCell.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 17.10.2021.
//

import UIKit

class catalogGoodsCollectionViewCell: UICollectionViewCell {
    
    
    //MARK: - объявление аутлетов
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var upperView: UIView!
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var priceProduct: UILabel!
    @IBOutlet var nameProduct: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    
    //MARK: - объекты
    var dataOfCell: GoodsOfCategory?
    
    
    //MARK: - клики
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        if favoriteButton.isSelected == true {
            favoriteButton.isSelected = false
            dataOfCell?.isFavorite = false
            print("favoriteButton.isSelected = false, good= \(dataOfCell?.name)")
            Persistence.shared.deleteGoodsFromFavorite(article: dataOfCell!.article)
        } else {
            favoriteButton.isSelected = true
            dataOfCell?.isFavorite = true
            print("favoriteButton.isSelected = true, good= \(dataOfCell?.name)")
            Persistence.shared.addGoodsToFavorite(good: dataOfCell!)
        }
//        AppSystemData.instance.VCMainCatalogDelegate?.mainCatalogCollectionUpdate()
    }
    
    
    var actionFromStartCellClosere: ( () -> Void )?
    
    @objc func gestureAction(tag: Int) {
        actionFromStartCellClosere!()
    }
    
    func startCell(tag: Int, action: @escaping () -> Void ) {
        
        favoriteButton.setImage(UIImage.init(named: "goodsInFavorite"), for: .selected)
        favoriteButton.setImage(UIImage.init(named: "goodsNoFavorite"), for: .disabled)
        
        actionFromStartCellClosere = action
        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureAction(tag:) ))
        self.addGestureRecognizer(gesture)
    }
    
}
