//
//  VCMainCatalog.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit
import Alamofire
import JGProgressHUD
import SwiftUI


class VCMainCatalog: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var slideProfileMenu: UIView!
    @IBOutlet var menuButtonView: UIView!
    @IBOutlet var menuButtonHorizonGesture: UIPanGestureRecognizer!
    @IBOutlet var catalogCategriesCollectionView: UICollectionView!
    @IBOutlet var constraintSecondMenuStrip2: NSLayoutConstraint!
    @IBOutlet var buttonSecondMenuCategories: UIView!
    @IBOutlet var buttonSecondMenuMens: UIView!
    @IBOutlet var buttonSecondMenuWomens: UIView!
    @IBOutlet var buttonSecondMenuSale: UIView!
    @IBOutlet var labelCategories: UILabel!
    @IBOutlet var labelMens: UILabel!
    @IBOutlet var labelWomens: UILabel!
    @IBOutlet var labelSales: UILabel!
    @IBOutlet var secondMenuStrip2: UIView!
    

    //MARK: - делегаты и переменные
    
    var menuState: Bool = false
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    var itemsPerRow: CGFloat = 2
    
    //MARK: - объекты
    
    let hud = JGProgressHUD()
    
    
    //MARK: - переходы
    
    func tapToCVCell(){
        if AppActualData.instance.activeCatalogMode == "catalog" {
            AppActualData.instance.activeCatalogMode = "subcategories"
            switch AppActualData.instance.activeCatalogCategory {
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
        } else if AppActualData.instance.activeCatalogMode == "subcategories" {
            AppActualData.instance.activeCatalogMode = "product"
        }
        mainCatalogCollectionUpdate()
        self.view.layoutIfNeeded()
    }
    
    func buttonSegueToVCCatalogGoods() {
        performSegue(withIdentifier: "segueToVCCatalogGoods", sender: nil)
    }

    
    
    //MARK: - анимация верхнего меню
    
    func changeModeIntoSecondMenu(activeMode: String, categoriesID: Int) {
        AppActualData.instance.activeCatalogMode = activeMode
        AppActualData.instance.activeCatalogCategory = categoriesID
        mainCatalogCollectionUpdate()
    }
    
    
    func borderLineForSecondMenu(button: Int) {
        UIView.animate(withDuration: 2.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
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
        }, completion: {isCompleted in })
    }
    
    
    func secondMenuHighliter(specifyLabel: UILabel?){
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

    
    //MARK: - клики, жесты
    
    @IBAction func handlerButtonTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            print("buttonTapp")
            slideProfileMenuPushed(gesture: gesture, gestureView: menuButtonView, isTap: true)
        }
    }
    
    @IBAction func handlerMenuButtonHorizonGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else {
          return
        }
        if gestureView.frame.origin.x + translation.x >= UIScreen.main.bounds.width - gesture.view!.frame.size.width - 255 && gestureView.frame.origin.x + translation.x <= UIScreen.main.bounds.width - gesture.view!.frame.size.width {
            gestureView.center = CGPoint(
              x: gestureView.center.x + translation.x,
              y: gestureView.center.y
            )
            slideProfileMenu.center = CGPoint(
                x: slideProfileMenu.center.x + translation.x,
                y: slideProfileMenu.center.y
              )
        }
        
        if gesture.state == .ended {
            slideProfileMenuPushed(gesture: gesture, gestureView: gestureView, isTap: false)
        }
        
        gesture.setTranslation(.zero, in: view)
        
        guard gesture.state == .ended else {
            return
        }
    }
    
    
    func slideProfileMenuPushed(gesture: UIGestureRecognizer, gestureView: UIView, isTap: Bool) {
        if slideProfileMenu.frame.origin.x >= UIScreen.main.bounds.width - 255 / 2 {
            if isTap == true {
                slideOpen()
            } else {
                slideClose()
            }
        }
        else {
            if isTap == true {
                slideClose()
            } else {
                slideOpen()
            }
        }
        
        func slideClose() {
            print("111")
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                gestureView.frame.origin.x = UIScreen.main.bounds.width - self.menuButtonView.frame.size.width
                self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width
            })
        }
        
        func slideOpen() {
            print("222")
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                gestureView.frame.origin.x = UIScreen.main.bounds.width - self.menuButtonView.frame.size.width - 255
                self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width - 255
            })
        }
        
    }
    
    
    @IBAction func catalogBackButtonAction(_ sender: Any) {
        if AppActualData.instance.activeCatalogMode == "subcategories" {
            AppActualData.instance.activeCatalogMode = "catalog"
            buttonCategoriesGesture(nil)
        } else if AppActualData.instance.activeCatalogMode == "product" {
            AppActualData.instance.activeCatalogMode = "subcategories"
            switch AppActualData.instance.activeCatalogCategory {
                case 0:
                    buttonMensGesture(nil)
                case 11:
                    buttonWomensGesture(nil)
                case 99:
                    buttonSaleGesture(nil)
                default:
                    hideSecondMenu()
            }
        }
        mainCatalogCollectionUpdate()
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func buttonCategoriesGesture(_ sender: Any?) {
        borderLineForSecondMenu(button: 1)
        AppActualData.instance.activeCatalogMode = "catalog"
        mainCatalogCollectionUpdate()
    }
    
    @IBAction func buttonMensGesture(_ sender: Any?) {
        borderLineForSecondMenu(button: 2)
        changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 0)
    }
    
    @IBAction func buttonWomensGesture(_ sender: Any?) {
        borderLineForSecondMenu(button: 3)
        changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 11)
    }
    
    @IBAction func buttonSaleGesture(_ sender: Any?) {
        borderLineForSecondMenu(button: 4)
        changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 99)
    }
    
    
    //MARK: - данные

    
    
    //MARK: - screen update
    
    func mainCatalogCollectionUpdate() {
        catalogCategriesCollectionView.reloadData()
    }
    
    func hudAppear() {
        hud.show(in: self.view)
    }
    
    func hudDisapper() {
        hud.dismiss(animated: true)
    }

    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppActualData.instance.VCMainCatalogDelegate = self
        
        menuButtonView.layer.cornerRadius = 8
        menuButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        menuButtonView.layer.borderWidth = 0
        menuButtonView.layer.borderColor = UIColor.clear.cgColor
        menuButtonView.clipsToBounds = true
        
        hud.textLabel.text = "Loading"
        CatalogData.instance.requestCategoriesData()
        AppActualData.instance.activeCatalogMode = "catalog"
        
        }
    
}


//MARK: - additional protocols

extension VCMainCatalog: UICollectionViewDataSource {
  // 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  // 2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("AppActualData.instance.activeCatalogMode= \(AppActualData.instance.activeCatalogMode)")
        print("3333")
        print("AppActualData.instance.activeCatalogMode= \(AppActualData.instance.activeCatalogMode)")
        print("AppActualData.instance.activeCatalogCategory= \(AppActualData.instance.activeCatalogCategory)")
        print("AppActualData.instance.activeCatalogSubCategory= \(AppActualData.instance.activeCatalogSubCategory)")

        
        switch AppActualData.instance.activeCatalogMode {
            case "catalog":
                print("444.count= \(CatalogData.instance.categoriesArray.count)")
                return CatalogData.instance.categoriesArray.count
            case "subcategories":
                print("555")
                let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppActualData.instance.activeCatalogCategory })!
                print("555.count= \(CatalogData.instance.categoriesArray[tempA].subCategories.count)")
                return CatalogData.instance.categoriesArray[tempA].subCategories.count
            case "product":
                print("666")
                let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppActualData.instance.activeCatalogCategory })!
                let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppActualData.instance.activeCatalogSubCategory })!
                print("222_subcategoryname = \(CatalogData.instance.categoriesArray[tempA].subCategories[tempB].name)")

                print("666.count = \(CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory.count)")
                return CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory.count
                default:
                    return 0
        }
        
  }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("4444")
        
        var cellCat: catalogCategriesCollectionViewCell?
        var cellProd: catalogGoodsCollectionViewCell?
        
        
        switch AppActualData.instance.activeCatalogMode {
            case "catalog":
                cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? catalogCategriesCollectionViewCell
                cellCat!.categoryImage.image = CatalogData.instance.categoriesArray[indexPath.row].imageUIImage//?.trim()
                print("imagePrint_catalog= \(CatalogData.instance.categoriesArray[indexPath.row].image)")
                cellCat!.nameCategory.text = CatalogData.instance.categoriesArray[indexPath.row].name
            
            case "subcategories":
                for data in CatalogData.instance.categoriesArray {
                    if data.sortOrder == AppActualData.instance.activeCatalogCategory {
                        print("AppActualData.instance.activeCatalogCategory222= \(AppActualData.instance.activeCatalogCategory)")
                        cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? catalogCategriesCollectionViewCell
                        cellCat!.categoryImage.image = data.subCategories[indexPath.row].iconUIImage //?.trim()
//                        CatalogData.instance.activeCatalogMode
                        cellCat!.nameCategory.text = data.subCategories[indexPath.row].name
                        print("name_subcategories= \(data.subCategories[indexPath.row].name)")
                    }
                }
            case "product":
                print("product case in CollectionView indexPath.row= \(indexPath.row)")
                let idOfCategory = AppActualData.instance.activeCatalogCategory
                let idOfSubCategory = AppActualData.instance.activeCatalogSubCategory
                let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == idOfCategory })!
                let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppActualData.instance.activeCatalogSubCategory })!
                
                cellProd = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? catalogGoodsCollectionViewCell
                cellProd!.productImage.image = CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory[indexPath.row].goodsUIImage //?.trim()
//                        CatalogData.instance.activeCatalogMode
                cellProd!.nameProduct.text = CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory[indexPath.row].name
                cellProd!.priceProduct.text = String(format: "$%.2f usd", CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory[indexPath.row].price)
                print("name_subcategories= \(CatalogData.instance.categoriesArray[tempA].subCategories[tempB].name)")
            default:
                print("default111")
                cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodsCell", for: indexPath) as? catalogCategriesCollectionViewCell
        }
        
        switch AppActualData.instance.activeCatalogMode {
            case "catalog", "subcategories":
                cellCat!.upperView.layer.cornerRadius = 30
                cellCat!.upperView.clipsToBounds = true
                
                let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
                let availableWidth = view.frame.width - CGFloat(paddingSpace)
                let widthPerItem = availableWidth / itemsPerRow
                cellCat!.widthConstraint.constant = widthPerItem
                cellCat!.heightConstraint.constant = widthPerItem * 1.3
            case "product":
                cellProd!.upperView.layer.cornerRadius = 30
                cellProd!.upperView.clipsToBounds = true
                
                let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
                let availableWidth = view.frame.width - CGFloat(paddingSpace)
                let widthPerItem = availableWidth / itemsPerRow
                cellProd!.widthConstraint.constant = widthPerItem
                cellProd!.heightConstraint.constant = widthPerItem * 1.3
            default:
                print("default222")
                cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodsCell", for: indexPath) as? catalogCategriesCollectionViewCell
        }
        
        switch AppActualData.instance.activeCatalogMode {
            case "catalog":
                cellCat!.startCell(tag: indexPath.row, action: {
                    AppActualData.instance.activeCatalogCategory = CatalogData.instance.categoriesArray[indexPath.row].sortOrder
                    self.tapToCVCell()
                } )
                return cellCat!
            case "subcategories":
                cellCat!.startCell(tag: indexPath.row, action: {
                    let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppActualData.instance.activeCatalogCategory } )!
                    
                    AppActualData.instance.activeCatalogSubCategory = CatalogData.instance.categoriesArray[tempA].subCategories[indexPath.row].id
                    CatalogData.instance.requestGoodsData()
                    self.tapToCVCell()
                } )
                return cellCat!
            default:
                cellProd!.startCell(tag: indexPath.row, action: {
                    
                    let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppActualData.instance.activeCatalogCategory } )!
                    let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppActualData.instance.activeCatalogSubCategory })!
                    
                    AppActualData.instance.activeCatalogProduct = CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory[indexPath.row].sortOrder
                    self.tapToCVCell()
                    self.buttonSegueToVCCatalogGoods()
                    
                } )
                return cellProd!
        }
        
//        return cell!
  }
}


// Dimension of CollectionView
extension VCMainCatalog: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      let paddingSpace = CGFloat(45.0) * (itemsPerRow + 1)
//      let availableWidth = view.frame.width - CGFloat(paddingSpace)
//      let widthPerItem = availableWidth / itemsPerRow
//        print("widthPerItem= \(widthPerItem)")
//        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
//    }

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

                    if data[Int(pixelIndex+1)] > 0xE0 && data[Int(pixelIndex+2)] > 0xE0 && data[Int(pixelIndex+3)] > 0xE0 { continue } // crop white

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

        let context = CGContext (data: bitmapData,
                                 width: width,
                                 height: height,
                                 bitsPerComponent: 8,      // bits per component
            bytesPerRow: bitmapBytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

        return context
    }

}


