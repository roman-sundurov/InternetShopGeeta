//
//  VCCart.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 09.11.2021.
//

import UIKit

class VCCart: UIViewController {
    
    
    //MARK: - объявление аутлетов
    @IBOutlet var favoritesCollectionView: UICollectionView!
    
    
    
    //MARK: - клики
    
    @IBAction func buttonCloseCartScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        cellOfCart?.productImage.image = UIImage.init(data: specificGood!.goodsUIImageData as! Data)
        cellOfCart?.nameLabel.text = specificGood?.name
        cellOfCart?.priceLabel.text = String(format: "$%.2f usd", specificGood!.price)
        
        return cellOfCart!
    }
    
    
}
