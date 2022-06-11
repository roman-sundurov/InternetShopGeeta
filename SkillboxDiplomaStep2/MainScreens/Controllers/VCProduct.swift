//
//  VCCatalogGoods.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 24.10.2021.
//

import UIKit

class VCProduct: UIViewController {
  // MARK: - объявление аутлетов
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
  @IBOutlet var toCartButton: UIButton!
  @IBOutlet var favoriteButton: UIButton!


  // MARK: - делегаты и переменные
  var tempA: Int?
  var tempB: Int?
  var tempC: Int?
  var specificGood: Products?
  var sizeOfGood: Size?


  // MARK: - объекты
  let alertEnterTheSize = UIAlertController(title: "Выберите размер товара", message: nil, preferredStyle: .alert)
  func createAlertNotRegistration() {
    alertEnterTheSize.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil ))
  }


  // MARK: - клики
  @IBAction func favoriteButtonAction(_ sender: Any) {
    let categoriesArray = CatalogData.instance.getCategoriesArray()
    if favoriteButton.isSelected == true {
      favoriteButton.isSelected = false
      specificGood?.isFavorite = false
      categoriesArray[tempA!].subCategories[tempB!].goodsOfCategory[tempC!].isFavorite = false
      Persistence.shared.deleteGoodsFromFavorite(article: specificGood!.article)
      AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionView.reloadData()
      print("VCGoods_favoriteButton.isSelected = false, good= \(specificGood?.name)")
    } else {
      favoriteButton.isSelected = true
      specificGood?.isFavorite = true
      categoriesArray[tempA!].subCategories[tempB!].goodsOfCategory[tempC!].isFavorite = true
      Persistence.shared.addGoodsToFavorite(good: specificGood!)
      AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionView.reloadData()
      print("VCGoods_favoriteButton.isSelected = true, good= \(specificGood?.name)")
    }
  }

  @IBAction func toCartButtonAction(_ sender: Any) {
    let categoriesArray = CatalogData.instance.getCategoriesArray()
    guard sizeOfGood!.sSize == true || sizeOfGood!.mSize == true || sizeOfGood!.lSize == true || sizeOfGood!.xlSize == true || sizeOfGood!.xxlSize == true else {
      self.present(alertEnterTheSize, animated: true, completion: nil)
      return
    }
    if toCartButton.isSelected == true {
      toCartButton.isSelected = false
      self.specificGood!.inCart = false
      Persistence.shared.deleteGoodsFromCart(article: specificGood!.article)
      transformSizeToBought(statusInCart: false)
    } else {
      tempA = categoriesArray.firstIndex(where: { $0.sortOrder == AppSystemData.instance.activeCatalogCategory })!
      toCartButton.isSelected = true
      specificGood!.inCart = true
      Persistence.shared.addGoodsToCart(
        good: specificGood!,
        size: Persistence.shared.newInstanceSizeOfGoode(size: sizeOfGood!),
        catalog: categoriesArray[tempA!].subCategories[tempB!].name
      )
      transformSizeToBought(statusInCart: true)
    }
  }

  @IBAction func buttonBackToCatalogScreen(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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


  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    createAlertNotRegistration()
    tempA = CatalogData.instance.getCategoriesArray().firstIndex {
      $0.sortOrder == AppSystemData.instance.activeCatalogCategory
    }
    tempB = CatalogData.instance.getCategoriesArray()[tempA!].subCategories.firstIndex {
      $0.id == AppSystemData.instance.activeCatalogSubCategory
    }
    tempC = CatalogData.instance.getCategoriesArray()[tempA!].subCategories[tempB!].goodsOfCategory.firstIndex {
      $0.sortOrder == AppSystemData.instance.activeCatalogProduct
    }
    goodDataUpdate()
    favoriteButton.isSelected = specificGood!.isFavorite ?? false
    labelNameOfCategory.text = CatalogData.instance.getCategoriesArray()[tempA!].name
    labelNameOfProduct.text = specificGood!.name
    labelPrice.text = String(format: "$%.2f usd", specificGood!.price)
    imageProduct.image = specificGood!.goodsUIImage // ?.trim()
    labelDescription.text = specificGood!.descriptionGoods

    buttonSizeS.setImage(UIImage.init(named: "sSizePainted"), for: .selected)
    buttonSizeM.setImage(UIImage.init(named: "mSizePainted"), for: .selected)
    buttonSizeL.setImage(UIImage.init(named: "lSizePainted"), for: .selected)
    buttonSizeXL.setImage(UIImage.init(named: "xlSizePainted"), for: .selected)
    buttonSizeXXL.setImage(UIImage.init(named: "xxlSizePainted"), for: .selected)

    toCartButton.setImage(UIImage.init(named: "AlreadyInCart"), for: .selected)
    toCartButton.setImage(UIImage.init(named: "AddInCart"), for: .disabled)

    favoriteButton.setImage(UIImage.init(named: "likePainted"), for: .selected)
    favoriteButton.setImage(UIImage.init(named: "likeEmpty"), for: .disabled)

    specificGood!.inCart! ? sizeAlreadyInCart() : nil
  }
}
