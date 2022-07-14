//
//  MainCatalogViewModel.swift
//  InternetShopGeeta
//
//  Created by Roman on 20.09.2021.
//

import Foundation
import UIKit

extension VCMainCatalog {
  // MARK: - переходы
  func logOut() {
    Persistence.shared.deleteUser()
    performSegue(withIdentifier: "segueToVCWelcome", sender: nil)
  }

  // Переключение верхнего меню
  func tapToCVCell() {
    if AppSystemData.instance.activeCatalogMode == "categories" {
      AppSystemData.instance.activeCatalogMode = "subcategories"
      switch AppSystemData.instance.activeCatalogCategory {
      case 0:
        borderLineForSecondMenu(button: 2)
      case 11:
        borderLineForSecondMenu(button: 3)
      case 99:
        borderLineForSecondMenu(button: 4)
      default:
        print("hideSecondMenu")
        hideSecondMenu()
      }
    } else if AppSystemData.instance.activeCatalogMode == "subcategories" {
      AppSystemData.instance.activeCatalogMode = "product"
    }
    catalogCollectionViewUpdate()
    self.view.layoutIfNeeded()
  }


  func buttonSegueToVCCatalogGoods() {
    performSegue(withIdentifier: "segueToVCCatalogGoods", sender: nil)
  }

    // MARK: - screen update
    func catalogCollectionViewUpdate() {
      applySnapshot()
      print("TAKT_Update")
    }

    func hudAppear() async {
      hud.show(in: mainView)
      print("hudAppear")
  }
    func hudDisapper() async {
      hud.dismiss(animated: true)
      print("hudDisapper")
    }


  // MARK: - анимация окон
  // Закрытие слайдера с профайлом без дополнительных сценариев
  func slideSimpleClose() {
    print("slideClose")
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions()
    ) {
      self.menuButtonView.frame.origin.x = UIScreen.main.bounds.width - self.menuButtonView.frame.size.width
      self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width
    }
  }

  // Открытие/закрытие слайдера с профайлом в зависимости от его метосположения
  func slideProfileMenuPushed(gesture: UIGestureRecognizer, gestureView: UIView, isTap: Bool) {
    if slideProfileMenu.frame.origin.x >= UIScreen.main.bounds.width - 255 / 2 {
      if isTap == true {
        slideOpen()
      } else {
        slideClose()
      }
    } else {
      if isTap == true {
        slideClose()
      } else {
        slideOpen()
      }
    }

    func slideClose() {
      print("111")
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: UIView.AnimationOptions()
      ) {
        gestureView.frame.origin.x = UIScreen.main.bounds.width - self.menuButtonView.frame.size.width
        self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width
      }
    }

    func slideOpen() {
      print("222")
      UIView.animate(
        withDuration: 0.3,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: UIView.AnimationOptions()
      ) {
        gestureView.frame.origin.x = UIScreen.main.bounds.width - self.menuButtonView.frame.size.width - 255
        self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width - 255
      }
    }
  }


  // MARK: - анимация верхнего меню
  func changeModeIntoSecondMenu(activeMode: String, categoriesID: Int) {
    print("AppSystemData.instance.activeCatalogMode888= \(AppSystemData.instance.activeCatalogMode)")
    AppSystemData.instance.activeCatalogMode = activeMode
    print("AppSystemData.instance.activeCatalogMode888_2= \(AppSystemData.instance.activeCatalogMode)")
    AppSystemData.instance.activeCatalogCategory = categoriesID
    catalogCollectionViewUpdate()
  }

  func borderLineForSecondMenu(button: Int) {
    UIView.animate(
      withDuration: 2.3,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        switch button {
        case 1:
          self.constraintSecondMenuStrip2.constant = self.buttonSecondMenuCategories.frame.origin.x + 10
          self.secondMenuHighliter(specifyLabel: self.labelCategories)
          print("borderLineForMenu 1")
        case 2:
          self.constraintSecondMenuStrip2.constant = self.buttonSecondMenuMens.frame.origin.x + 10
          print("borderLineForMenu 2")
          self.secondMenuHighliter(specifyLabel: self.labelMens)
        case 3:
          self.constraintSecondMenuStrip2.constant = self.buttonSecondMenuWomens.frame.origin.x + 10
          self.secondMenuHighliter(specifyLabel: self.labelWomens)
          print("borderLineForMenu 3")
        case 4:
          self.constraintSecondMenuStrip2.constant = self.buttonSecondMenuSale.frame.origin.x + 10
          self.secondMenuHighliter(specifyLabel: self.labelSales)
          print("borderLineForMenu 4")
        default:
          print("Error with borderLineForMenu")
        }
      },
      completion: { _ in })
  }

  func secondMenuHighliter(specifyLabel: UILabel?) {
    if specifyLabel == nil {
      secondMenuStrip2.isHidden = true
    } else {
      secondMenuStrip2.isHidden = false
    }
    switch specifyLabel {
    case labelCategories:
      labelCategories.textColor = UIColor.init(named: "Purple")
      labelMens.textColor = UIColor.init(named: "SpecialGrey2")
      labelWomens.textColor = UIColor.init(named: "SpecialGrey2")
      labelSales.textColor = UIColor.init(named: "SpecialGrey2")
      print("111")
    case labelMens:
      labelCategories.textColor = UIColor.init(named: "SpecialGrey2")
      labelMens.textColor = UIColor.init(named: "Purple")
      labelWomens.textColor = UIColor.init(named: "SpecialGrey2")
      labelSales.textColor = UIColor.init(named: "SpecialGrey2")
      print("222")
    case labelWomens:
      labelCategories.textColor = UIColor.init(named: "SpecialGrey2")
      labelMens.textColor = UIColor.init(named: "SpecialGrey2")
      labelWomens.textColor = UIColor.init(named: "Purple")
      labelSales.textColor = UIColor.init(named: "SpecialGrey2")
      print("333")
    case labelSales:
      labelCategories.textColor = UIColor.init(named: "SpecialGrey2")
      labelMens.textColor = UIColor.init(named: "SpecialGrey2")
      labelWomens.textColor = UIColor.init(named: "SpecialGrey2")
      labelSales.textColor = UIColor.init(named: "Purple")
      print("444")
    default:
      print("SecondMenu is hided")
      labelCategories.textColor = UIColor.init(named: "SpecialGrey2")
      labelMens.textColor = UIColor.init(named: "SpecialGrey2")
      labelWomens.textColor = UIColor.init(named: "SpecialGrey2")
      labelSales.textColor = UIColor.init(named: "SpecialGrey2")
    }
  }

  func hideSecondMenu() {
    secondMenuHighliter(specifyLabel: nil)
  }


  // MARK: - данные
  func applySnapshot(animatingDifferences: Bool = true) {
    print("AppSystemData.instance.activeCatalogMode111= \(AppSystemData.instance.activeCatalogMode)")
    let categoriesArray = CatalogData.instance.getCategoriesArray()

    switch AppSystemData.instance.activeCatalogMode {
    case "categories":
      print("applySnapshot catalog")
      var snapshot = SnapshotAliasCatalogMode()
      snapshot.appendSections([.main])
      snapshot.appendItems(categoriesArray)
      dataSourceCategoriesMode = makeDataSourceCategoriesMode()
      dataSourceCategoriesMode.apply(snapshot, animatingDifferences: animatingDifferences)
    case "subcategories":
      print("applySnapshot subcategories")
      let tempA: Int = categoriesArray.firstIndex(where: {
        $0.sortOrder == AppSystemData.instance.activeCatalogCategory
      })!
      let subCategories = categoriesArray[tempA].subCategories
      var snapshot = SnapshotAliasSubcategoriesMode()
      snapshot.appendSections([.main])
      snapshot.appendItems(subCategories)
      dataSourceSubcategoriesMode = makeDataSourceSubcategoriesMode()
      dataSourceSubcategoriesMode.apply(snapshot, animatingDifferences: animatingDifferences)
    case "product":
      print("applySnapshot product,CatalogData.instance.categoriesArray= \(categoriesArray.count)")
      let tempA: Int = categoriesArray.firstIndex(where: {
        $0.sortOrder == AppSystemData.instance.activeCatalogCategory
      })!
      let tempB: Int = categoriesArray[tempA].subCategories.firstIndex(where: {
        $0.id == AppSystemData.instance.activeCatalogSubCategory
      })!
      let specificSubcategory = categoriesArray[tempA].subCategories[tempB].goodsOfCategory

      var snapshot = SnapshotAliasProductMode()
      snapshot.appendSections([.main])
      snapshot.appendItems(specificSubcategory)
      print("tempA111= \(tempA)")
      print("tempB111= \(tempB)")
      print("specificSubcategory.count111= \(specificSubcategory.count)")
      dataSourceProductMode = makeDataSourceProductMode()
      dataSourceProductMode.apply(snapshot, animatingDifferences: animatingDifferences)
    default:
      return
    }
  }

  func makeDataSourceCategoriesMode() -> DataSourceAliastCatalogMode {
    print("9000")
    print("makeDataSource catalog")
    let categoriesArray = CatalogData.instance.getCategoriesArray()
    let dataSource = DataSourceAliastCatalogMode(collectionView: catalogCollectionView) { collectionView, indexPath, _ -> UICollectionViewCell? in
      var cellCat: CatalogCategriesCollectionViewCell?

      // Set cell's content
      cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CatalogCategriesCollectionViewCell
      cellCat?.categoryImage.image = categoriesArray[indexPath.row].imageUIImage
      print("imagePrint_catalog= \(categoriesArray[indexPath.row].image)")
      cellCat?.nameCategory.text = categoriesArray[indexPath.row].name

      // Set constraints
      cellCat?.upperView.layer.cornerRadius = 30
      cellCat?.upperView.clipsToBounds = true

      let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
      let availableWidth = self.view.frame.width - CGFloat(paddingSpace)
      let widthPerItem = availableWidth / self.itemsPerRow
      cellCat?.widthConstraint.constant = widthPerItem
      cellCat?.heightConstraint.constant = widthPerItem * 1.3

      // Настройка Closures, которое срабатывает при клике на ячейку
      cellCat?.startCell(tag: indexPath.row) {
        AppSystemData.instance.activeCatalogCategory = categoriesArray[indexPath.row].sortOrder
        CatalogData.instance.requestSubcategoriesData()
        self.tapToCVCell()
      }
      return cellCat
    }
    return dataSource
  }

  func makeDataSourceSubcategoriesMode() -> DataSourceAliastSubcategoriesMode {
    print("9001")
    print("makeDataSource subcategories")
    let categoriesArray = CatalogData.instance.getCategoriesArray()
    let dataSource = DataSourceAliastSubcategoriesMode(collectionView: catalogCollectionView) { collectionView, indexPath, subCategories -> UICollectionViewCell? in
      var cellCat: CatalogCategriesCollectionViewCell?
      print("7777_AppSystemData.instance.activeCatalogCategory= \(AppSystemData.instance.activeCatalogCategory)")

      // Set cell's content
      for data in categoriesArray where data.sortOrder == AppSystemData.instance.activeCatalogCategory {
        print("AppActualData.instance.activeCatalogCategory222= \(AppSystemData.instance.activeCatalogCategory)")
        cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CatalogCategriesCollectionViewCell
        cellCat?.categoryImage.image = data.subCategories[indexPath.row].iconUIImage
        cellCat?.nameCategory.text = data.subCategories[indexPath.row].name
        print("name_subcategories= \(data.subCategories[indexPath.row].name)")
      }

      // Set constraints
      cellCat?.upperView.layer.cornerRadius = 30
      cellCat?.upperView.clipsToBounds = true
      let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
      let availableWidth = self.view.frame.width - CGFloat(paddingSpace)
      let widthPerItem = availableWidth / self.itemsPerRow
      cellCat?.widthConstraint.constant = widthPerItem
      cellCat?.heightConstraint.constant = widthPerItem * 1.3
      // Настройка Closures, которое срабатывает при клике на ячейку
      cellCat?.startCell(tag: indexPath.row) {
        let tempA: Int = categoriesArray.firstIndex(where: {
          $0.sortOrder == AppSystemData.instance.activeCatalogCategory
        })!
        AppSystemData.instance.activeCatalogSubCategory = categoriesArray[tempA].subCategories[indexPath.row].id
        CatalogData.instance.requestGoodsData()
        self.tapToCVCell()
      }
      return cellCat!
    }
    return dataSource
  }

  func makeDataSourceProductMode() -> DataSourceAliasProductMode {
    print("9002")
    print("makeDataSource product")
    let categoriesArray = CatalogData.instance.getCategoriesArray()
    let dataSource = DataSourceAliasProductMode(collectionView: catalogCollectionView, cellProvider: { collectionView, indexPath, subCategories -> UICollectionViewCell? in
      var cellProd: CatalogProductsCollectionViewCell?

      // Set cell's content
      print("product case in CollectionView indexPath.row= \(indexPath.row)")
      let idOfCategory = AppSystemData.instance.activeCatalogCategory
      // let idOfSubCategory = AppSystemData.instance.activeCatalogSubCategory
      let tempA: Int = categoriesArray.firstIndex(where: { $0.sortOrder == idOfCategory })!
      let tempB: Int = categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppSystemData.instance.activeCatalogSubCategory
      })!
      let goodsData = categoriesArray[tempA].subCategories[tempB].goodsOfCategory[indexPath.row]

      cellProd = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? CatalogProductsCollectionViewCell
      cellProd?.productImage.image = goodsData.goodsUIImage
      cellProd?.nameProduct.text = goodsData.name
      cellProd?.priceProduct.text = String(format: "$%.2f usd", goodsData.price)
      cellProd?.favoriteButton.isSelected = goodsData.isFavorite!
      print("cellProd!.favoriteButton.isSelected= \(cellProd!.favoriteButton.isSelected), name= \(cellProd?.nameProduct.text)")
      cellProd?.dataOfCell = goodsData
      print("name_subcategories= \(categoriesArray[tempA].subCategories[tempB].name)")

      // Set constraints
      cellProd?.upperView.layer.cornerRadius = 30
      cellProd?.upperView.clipsToBounds = true

      let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
      let availableWidth = self.view.frame.width - CGFloat(paddingSpace)
      let widthPerItem = availableWidth / self.itemsPerRow
      cellProd?.widthConstraint.constant = widthPerItem
      cellProd?.heightConstraint.constant = widthPerItem * 1.3

      // Настройка Closures, которое срабатывает при клике на ячейку
      cellProd?.startCell(indexPath: indexPath) {
        let tempA: Int = categoriesArray.firstIndex {
          $0.sortOrder == AppSystemData.instance.activeCatalogCategory
        }!
        let tempB: Int = categoriesArray[tempA].subCategories.firstIndex {
          $0.id == AppSystemData.instance.activeCatalogSubCategory
        }!
        AppSystemData.instance.activeCatalogProduct = CatalogData
          .instance
          .getCategoriesArray()[tempA]
          .subCategories[tempB]
          .goodsOfCategory[indexPath.row]
          .sortOrder
        self.tapToCVCell()
        self.buttonSegueToVCCatalogGoods()
      }
      return cellProd!
    })
    return dataSource
  }
}


// MARK: - Dimension of CollectionView
extension VCMainCatalog: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left * 1.5
  }
}


extension UIImage {
  func trim() -> UIImage {
    let newRect = self.cropRect
    if let imageRef = self.cgImage!.cropping(to: newRect) {
      return UIImage(cgImage: imageRef)
    }
    return self
  }

  var cropRect: CGRect {
    guard let cgImage = self.cgImage,
      let context = createARGBBitmapContextFromImage(inImage: cgImage) else {
        return CGRect.zero
    }

    let height = CGFloat(cgImage.height)
    let width = CGFloat(cgImage.width)
    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    context.draw(cgImage, in: rect)

    guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else {
      return CGRect.zero
    }

    var lowX = width
    var lowY = height
    var highX: CGFloat = 0
    var highY: CGFloat = 0
    let heightInt = Int(height)
    let widthInt = Int(width)

    // Filter through data and look for non-transparent pixels.
    for y in 0 ..< heightInt {
      let y = CGFloat(y)

      for x in 0 ..< widthInt {
        let x = CGFloat(x)
        let pixelIndex = (width * y + x) * 4 /* 4 for A, R, G, B */

        if data[Int(pixelIndex)] == 0 { continue } // crop transparent

        if data[Int(pixelIndex + 1)] > 0xE0 && data[Int(pixelIndex + 2)] > 0xE0 && data[Int(pixelIndex + 3)] > 0xE0 { continue } // crop white

        lowX = min(x, lowX)
        highX = max(x, highX)

        lowY = min(y, lowY)
        highY = max(y, highY)
      }
    }
    return CGRect(x: lowX, y: lowY, width: highX - lowX, height: highY - lowY)
  }

  func createARGBBitmapContextFromImage(inImage: CGImage) -> CGContext? {
    let width = inImage.width
    let height = inImage.height

    let bitmapBytesPerRow = width * 4
    let bitmapByteCount = bitmapBytesPerRow * height

    let colorSpace = CGColorSpaceCreateDeviceRGB()

    let bitmapData = malloc(bitmapByteCount)
    if bitmapData == nil {
      return nil
    }

    let context = CGContext(
      data: bitmapData,
      width: width,
      height: height,
      bitsPerComponent: 8,      // bits per component
      bytesPerRow: bitmapBytesPerRow,
      space: colorSpace,
      bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
    )

    return context
  }
}
