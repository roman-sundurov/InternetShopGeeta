//
//  CartCollectionViewCell.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 21.11.2021.
//

import UIKit

class CartCollectionViewCell: UICollectionViewCell {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameOfCategoryLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var buttonSize: UIButton!
    
    var specificGood: CartGoodsDiffable?
    
    
    //MARK: - клики
    
    @IBAction func deleteProductButton(_ sender: Any) {
        Persistence.shared.deleteGoodsFromCart(article: specificGood!.article)
        AppSystemData.instance.vcCart?.updateData()
    }
    
}
