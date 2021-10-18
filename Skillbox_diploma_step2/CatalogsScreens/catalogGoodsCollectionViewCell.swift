//
//  catalogGoodsCollectionViewCell.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 17.10.2021.
//

import UIKit

class catalogGoodsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var upperView: UIView!
    @IBOutlet var widthConstraint: NSLayoutConstraint!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var priceProduct: UILabel!
    @IBOutlet var nameProduct: UILabel!
    
    
    func startCell(tag: Int, action: @escaping () -> Void ) {
        
//        priceProduct.text = String(format: "%.2f", delegateScreen1!.returnDataArrayOfOperations()[specVar].amount)
        
//        specialTag = tag
//        actionFromStartCellClosere = action
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureAction(tag:) ))
//        self.addGestureRecognizer(gesture)
    }
    
}
