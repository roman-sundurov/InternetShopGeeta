//
//  VCCatalogGoods.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 24.10.2021.
//

import UIKit

class VCCatalogGoods: UIViewController {
    
    
        //MARK: - объявление аутлетов
    
    @IBOutlet var labelNameOfCategory: UILabel!
    @IBOutlet var labelNameOfProduct: UILabel!
    @IBOutlet var labelPrice: UILabel!
    @IBOutlet var imageProduct: UIImageView!
    @IBOutlet var labelDescription: UILabel!
   
    @IBOutlet var buttonSizeS: UIButton!
    @IBOutlet var buttonSizeM: UIButton!
    @IBOutlet var buttonSizeL: UIButton!
    @IBOutlet var buttonSizeXL: UIButton!
    @IBOutlet var buttonSizeXXL: UIButton!
    
    
        //MARK: - клики
    
    @IBAction func buttonCloseGoodsScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func newSizeSelected(newSize: String) {
        switch newSize {
            case "S":
                buttonSizeM.isSelected = false
                buttonSizeL.isSelected = false
                buttonSizeXL.isSelected = false
                buttonSizeXXL.isSelected = false
                buttonSizeS.isSelected = true
            case "M":
                buttonSizeS.isSelected = false
                buttonSizeL.isSelected = false
                buttonSizeXL.isSelected = false
                buttonSizeXXL.isSelected = false
                buttonSizeM.isSelected = true
            case "L":
                buttonSizeS.isSelected = false
                buttonSizeM.isSelected = false
                buttonSizeXL.isSelected = false
                buttonSizeXXL.isSelected = false
                buttonSizeL.isSelected = true
            case "XL":
                buttonSizeS.isSelected = false
                buttonSizeM.isSelected = false
                buttonSizeL.isSelected = false
                buttonSizeXXL.isSelected = false
                buttonSizeXL.isSelected = true
            case "XXL":
                buttonSizeS.isSelected = false
                buttonSizeM.isSelected = false
                buttonSizeL.isSelected = false
                buttonSizeXL.isSelected = false
                buttonSizeXXL.isSelected = true
            default:
                return
        }
    }
    
    
    @IBAction func buttonSizeS(_ sender: Any) {
        newSizeSelected(newSize: "S")
    }
    
    @IBAction func buttonSizeM(_ sender: Any) {
        newSizeSelected(newSize: "M")
    }
    
    @IBAction func buttonSizeL(_ sender: Any) {
        newSizeSelected(newSize: "L")
    }
    
    @IBAction func buttonSizeXL(_ sender: Any) {
        newSizeSelected(newSize: "XL")
    }
    
    @IBAction func buttonSizeXXL(_ sender: Any) {
        newSizeSelected(newSize: "XXL")
    }
    
    
    
        //MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppSystemData.instance.activeCatalogCategory })!
        let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppSystemData.instance.activeCatalogSubCategory })!
        let tempC: Int = CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory.firstIndex(where: { $0.sortOrder == AppSystemData.instance.activeCatalogProduct })!
        let specificGood = CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory[tempC]
       
        labelNameOfCategory.text = CatalogData.instance.categoriesArray[tempA].name
        labelNameOfProduct.text = specificGood.name
        labelPrice.text = String(format: "$%.2f usd", specificGood.price)
        imageProduct.image = specificGood.goodsUIImage //?.trim()
        labelDescription.text = specificGood.description

        
        buttonSizeS.setImage(UIImage.init(named: "sSizePainted"), for: .selected)
        buttonSizeM.setImage(UIImage.init(named: "mSizePainted"), for: .selected)
        buttonSizeL.setImage(UIImage.init(named: "lSizePainted"), for: .selected)
        buttonSizeXL.setImage(UIImage.init(named: "xlSizePainted"), for: .selected)
        buttonSizeXXL.setImage(UIImage.init(named: "xxlSizePainted"), for: .selected)
        
    }

}
