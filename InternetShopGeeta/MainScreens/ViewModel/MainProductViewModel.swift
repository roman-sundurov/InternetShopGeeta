//
//  MainProductViewModel.swift
//  InternetShopGeeta
//
//  Created by Roman on 11.06.2022.
//

import Foundation
import UIKit

extension VCProduct {
  func sizeAlreadyInCart() {
    print("sizeAlreadyInCart, specificGood?.sizeInCart?.sSize= \(specificGood?.sizeInCart?.sSize)")
    if specificGood?.sizeInCart?.sSize == true {
      buttonSizeS.setImage(UIImage.init(named: "sSizeBought"), for: .selected)
      buttonSizeS.isSelected = true
      print("sizeAlreadyInCart sizeInCart?.sSize")
    }

    if specificGood?.sizeInCart?.mSize == true {
      buttonSizeM.setImage(UIImage.init(named: "mSizeBought"), for: .selected)
      buttonSizeM.isSelected = true
      print("sizeAlreadyInCart sizeInCart?.mSize")
    }

    if specificGood?.sizeInCart?.lSize == true {
      buttonSizeL.setImage(UIImage.init(named: "lSizeBought"), for: .selected)
      buttonSizeL.isSelected = true
      print("sizeAlreadyInCart sizeInCart?.lSize")
    }

    if specificGood?.sizeInCart?.xlSize == true {
      buttonSizeXL.setImage(UIImage.init(named: "xlSizeBought"), for: .selected)
      buttonSizeXL.isSelected = true
      print("sizeAlreadyInCart sizeInCart?.xlSize")
    }

    if specificGood?.sizeInCart?.xxlSize == true {
      buttonSizeXXL.setImage(UIImage.init(named: "xxlSizeBought"), for: .selected)
      buttonSizeXXL.isSelected = true
      print("sizeAlreadyInCart sizeInCart?.xxlSize")
    }
    toCartButton.isSelected = true
  }

  func transformSizeToBought(statusInCart: Bool) {
    if statusInCart == true {
      if specificGood?.sizeInCart?.sSize == true {
        buttonSizeS.setImage(UIImage.init(named: "sSizeBought"), for: .selected)
        print("sizeInCart?.sSize")
      }
      if specificGood?.sizeInCart?.mSize == true {
        buttonSizeM.setImage(UIImage.init(named: "mSizeBought"), for: .selected)
        print("sizeInCart?.mSize")
      }
      if specificGood?.sizeInCart?.lSize == true {
        buttonSizeL.setImage(UIImage.init(named: "lSizeBought"), for: .selected)
        print("sizeInCart?.lSize")
      }
      if specificGood?.sizeInCart?.xlSize == true {
        buttonSizeXL.setImage(UIImage.init(named: "xlSizeBought"), for: .selected)
        print("sizeInCart?.xlSize")
      }
      if specificGood?.sizeInCart?.xxlSize == true {
        buttonSizeXXL.setImage(UIImage.init(named: "xxlSizeBought"), for: .selected)
        print("sizeInCart?.xxlSize")
      }
    } else {
      if specificGood?.sizeInCart?.sSize == true {
        buttonSizeS.setImage(UIImage.init(named: "sSizePainted"), for: .selected)
      }
      if specificGood?.sizeInCart?.mSize == true {
        buttonSizeM.setImage(UIImage.init(named: "mSizePainted"), for: .selected)
      }

      if specificGood?.sizeInCart?.lSize == true {
        buttonSizeL.setImage(UIImage.init(named: "lSizePainted"), for: .selected)
      }

      if specificGood?.sizeInCart?.xlSize == true {
        buttonSizeXL.setImage(UIImage.init(named: "xlSizePainted"), for: .selected)
      }

      if specificGood?.sizeInCart?.xxlSize == true {
        buttonSizeXXL.setImage(UIImage.init(named: "xxlSizePainted"), for: .selected)
      }
    }
  }

  func newSizeSelected(newSize: String) {
    print("specificGood?.inCart= \(specificGood?.inCart)")
    if specificGood?.inCart == false {
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
        print("77721")
      case "XXL":
        buttonSizeS.isSelected = false
        buttonSizeM.isSelected = false
        buttonSizeL.isSelected = false
        buttonSizeXL.isSelected = false
        buttonSizeXXL.isSelected = true
      default:
        return
      }
      print("7773")
      print("specificGood= \(specificGood)")
      print("sizeOfGood= \(sizeOfGood)")
      sizeOfGood!.sSize = buttonSizeS.isSelected
      sizeOfGood!.mSize = buttonSizeM.isSelected
      sizeOfGood!.lSize = buttonSizeL.isSelected
      sizeOfGood!.xlSize = buttonSizeXL.isSelected
      sizeOfGood!.xxlSize = buttonSizeXXL.isSelected
      print("7774")
      specificGood?.sizeInCart? = sizeOfGood!
    }
  }


    // MARK: - данные
    func goodDataUpdate() {
      tempA = CatalogData
        .instance
        .getCategoriesArray()
        .firstIndex { $0.sortOrder == AppSystemData.instance.activeCatalogCategory }
      tempB = CatalogData
        .instance
        .getCategoriesArray()[tempA!]
        .subCategories
        .firstIndex { $0.id == AppSystemData.instance.activeCatalogSubCategory }
      tempC = CatalogData
        .instance
        .getCategoriesArray()[tempA!]
        .subCategories[tempB!]
        .goodsOfCategory
        .firstIndex { $0.sortOrder == AppSystemData.instance.activeCatalogProduct }
      specificGood = CatalogData.instance.getCategoriesArray()[tempA!].subCategories[tempB!].goodsOfCategory[tempC!]
      sizeOfGood = Size.init(
        sSize: specificGood!.sizeInCart!.sSize,
        mSize: specificGood!.sizeInCart!.mSize,
        lSize: specificGood!.sizeInCart!.lSize,
        xlSize: specificGood!.sizeInCart!.xlSize,
        xxlSize: specificGood!.sizeInCart!.xxlSize
      )
    }
}
