//
//  VCMainCatalog.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit
import Alamofire
import JGProgressHUD

protocol VCMainCatalogProtocol {
    func updateItemInCollectionView(indexPath: IndexPath, nameGood: String)
}


class VCMainCatalog: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var slideProfileMenu: UIView!
    @IBOutlet var menuButtonView: UIView!
    @IBOutlet var menuButtonHorizonGesture: UIPanGestureRecognizer!
    @IBOutlet var catalogCollectionView: UICollectionView!
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
    
    enum SectionCategories {
      case main
    }
    
    private lazy var dataSourceCategoriesMode = makeDataSourceCategoriesMode()
    private lazy var dataSourceSubcategoriesMode = makeDataSourceSubcategoriesMode()
    private lazy var dataSourceProductMode = makeDataSourceProductMode()
    
    typealias DataSourceAliastCatalogMode = UICollectionViewDiffableDataSource<SectionCategories, Categories>
    typealias SnapshotAliasCatalogMode = NSDiffableDataSourceSnapshot<SectionCategories, Categories>
    
    typealias DataSourceAliastSubcategoriesMode = UICollectionViewDiffableDataSource<SectionCategories, SubCategories>
    typealias SnapshotAliasSubcategoriesMode = NSDiffableDataSourceSnapshot<SectionCategories, SubCategories>
    
    typealias DataSourceAliasProductMode = UICollectionViewDiffableDataSource<SectionCategories, Products>
    typealias SnapshotAliasProductMode = NSDiffableDataSourceSnapshot<SectionCategories, Products>
    
    var menuState: Bool = false
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    var itemsPerRow: CGFloat = 2
    
    
    //MARK: - данные
    
    func applySnapshot(animatingDifferences: Bool = true) {
        print("AppSystemData.instance.activeCatalogMode111= \(AppSystemData.instance.activeCatalogMode)")
        
        switch AppSystemData.instance.activeCatalogMode {
            case "categories":
                print("applySnapshot catalog")
                var snapshot = SnapshotAliasCatalogMode()
                snapshot.appendSections([.main])
                snapshot.appendItems(CatalogData.instance.categoriesArray)
                
                dataSourceCategoriesMode = makeDataSourceCategoriesMode()
                
                dataSourceCategoriesMode.apply(snapshot, animatingDifferences: animatingDifferences)
                
            case "subcategories":
                print("applySnapshot subcategories")
                let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppSystemData.instance.activeCatalogCategory })!
                let subCategories = CatalogData.instance.categoriesArray[tempA].subCategories

                var snapshot = SnapshotAliasSubcategoriesMode()
                snapshot.appendSections([.main])
                snapshot.appendItems(subCategories)
                
                dataSourceSubcategoriesMode = makeDataSourceSubcategoriesMode()
                
                dataSourceSubcategoriesMode.apply(snapshot, animatingDifferences: animatingDifferences)

            case "product":
                print("applySnapshot product, CatalogData.instance.categoriesArray= \(CatalogData.instance.categoriesArray.count)")
                let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppSystemData.instance.activeCatalogCategory })!
                let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppSystemData.instance.activeCatalogSubCategory })!
                let specificSubcategory = CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory

                var snapshot = SnapshotAliasProductMode()
                snapshot.appendSections([.main])
                snapshot.appendItems(specificSubcategory)
//                snapshot.appendItems(section.videos, toSection: section)
                
                dataSourceProductMode = makeDataSourceProductMode()
                
                dataSourceProductMode.apply(snapshot, animatingDifferences: animatingDifferences)

//                categoriesArray.forEach { section in snapshot.appendItems(section.subCategories, toSection: section) }
            default:
                return
        }
        
    }
    
    
    func makeDataSourceCategoriesMode() -> DataSourceAliastCatalogMode {
        print("9000")
        print("makeDataSource catalog")
        
        let dataSource = DataSourceAliastCatalogMode(collectionView: catalogCollectionView, cellProvider: { (collectionView, indexPath, subCategories) -> UICollectionViewCell? in
            
            var cellCat: catalogCategriesCollectionViewCell?
    
            //Set cell's content
            cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? catalogCategriesCollectionViewCell
            cellCat!.categoryImage.image = CatalogData.instance.categoriesArray[indexPath.row].imageUIImage
            print("imagePrint_catalog= \(CatalogData.instance.categoriesArray[indexPath.row].image)")
            cellCat!.nameCategory.text = CatalogData.instance.categoriesArray[indexPath.row].name
            
            //Set constraints
            cellCat!.upperView.layer.cornerRadius = 30
            cellCat!.upperView.clipsToBounds = true
            
            let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
            let availableWidth = self.view.frame.width - CGFloat(paddingSpace)
            let widthPerItem = availableWidth / self.itemsPerRow
            cellCat!.widthConstraint.constant = widthPerItem
            cellCat!.heightConstraint.constant = widthPerItem * 1.3
            
            //Настройка Closures, которое срабатывает при клике на ячейку
            cellCat!.startCell(tag: indexPath.row, action: {
                AppSystemData.instance.activeCatalogCategory = CatalogData.instance.categoriesArray[indexPath.row].sortOrder
                self.tapToCVCell()
            })
            return cellCat
        })
        return dataSource
    }
    
    
    func makeDataSourceSubcategoriesMode() -> DataSourceAliastSubcategoriesMode {
        print("9001")
        print("makeDataSource subcategories")

        let dataSource = DataSourceAliastSubcategoriesMode(collectionView: catalogCollectionView, cellProvider: { (collectionView, indexPath, subCategories) -> UICollectionViewCell? in

            var cellCat: catalogCategriesCollectionViewCell?

            //Set cell's content
            for data in CatalogData.instance.categoriesArray {
                if data.sortOrder == AppSystemData.instance.activeCatalogCategory {
                    print("AppActualData.instance.activeCatalogCategory222= \(AppSystemData.instance.activeCatalogCategory)")
                    cellCat = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? catalogCategriesCollectionViewCell
                    cellCat!.categoryImage.image = data.subCategories[indexPath.row].iconUIImage
                    cellCat!.nameCategory.text = data.subCategories[indexPath.row].name
                    print("name_subcategories= \(data.subCategories[indexPath.row].name)")
                }
            }

            //Set constraints
            cellCat!.upperView.layer.cornerRadius = 30
            cellCat!.upperView.clipsToBounds = true

            let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
            let availableWidth = self.view.frame.width - CGFloat(paddingSpace)
            let widthPerItem = availableWidth / self.itemsPerRow
            cellCat!.widthConstraint.constant = widthPerItem
            cellCat!.heightConstraint.constant = widthPerItem * 1.3

            //Настройка Closures, которое срабатывает при клике на ячейку
            cellCat!.startCell(tag: indexPath.row, action: {
                let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppSystemData.instance.activeCatalogCategory } )!

                AppSystemData.instance.activeCatalogSubCategory = CatalogData.instance.categoriesArray[tempA].subCategories[indexPath.row].id
                CatalogData.instance.requestGoodsData()
                self.tapToCVCell()
            })
            return cellCat!

             })
        return dataSource
    }
    
    
    func makeDataSourceProductMode() -> DataSourceAliasProductMode {
        print("9002")
        print("makeDataSource product")

        let dataSource = DataSourceAliasProductMode(collectionView: catalogCollectionView, cellProvider: { (collectionView, indexPath, subCategories) -> UICollectionViewCell? in

            var cellProd: catalogProductsCollectionViewCell?

            //Set cell's content
            print("product case in CollectionView indexPath.row= \(indexPath.row)")
            let idOfCategory = AppSystemData.instance.activeCatalogCategory
            let idOfSubCategory = AppSystemData.instance.activeCatalogSubCategory
            let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == idOfCategory })!
            let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppSystemData.instance.activeCatalogSubCategory })!
            let goodsData = CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory[indexPath.row]

            cellProd = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? catalogProductsCollectionViewCell
            cellProd!.productImage.image = goodsData.goodsUIImage
            cellProd!.nameProduct.text = goodsData.name
            cellProd!.priceProduct.text = String(format: "$%.2f usd", goodsData.price)
            cellProd!.favoriteButton.isSelected = goodsData.isFavorite!
            print("cellProd!.favoriteButton.isSelected= \(cellProd!.favoriteButton.isSelected), name= \(cellProd?.nameProduct.text)")
            cellProd?.dataOfCell = goodsData
            print("name_subcategories= \(CatalogData.instance.categoriesArray[tempA].subCategories[tempB].name)")

            //Set constraints
            cellProd!.upperView.layer.cornerRadius = 30
            cellProd!.upperView.clipsToBounds = true

            let paddingSpace = self.sectionInsets.left * (self.itemsPerRow + 1)
            let availableWidth = self.view.frame.width - CGFloat(paddingSpace)
            let widthPerItem = availableWidth / self.itemsPerRow
            cellProd!.widthConstraint.constant = widthPerItem
            cellProd!.heightConstraint.constant = widthPerItem * 1.3

            //Настройка Closures, которое срабатывает при клике на ячейку
            cellProd!.startCell(indexPath: indexPath, action: {

                let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == AppSystemData.instance.activeCatalogCategory } )!
                let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppSystemData.instance.activeCatalogSubCategory })!

                AppSystemData.instance.activeCatalogProduct = CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory[indexPath.row].sortOrder
                self.tapToCVCell()
                self.buttonSegueToVCCatalogGoods()
            })
            return cellProd!
        })
        return dataSource

    }

    
    //MARK: - объекты
    
    let hud = JGProgressHUD()
    
    
    //MARK: - переходы
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VCProduct, segue.identifier == "segueToVCCatalogGoods" {
            //Something
        }
    }
    
    
    func logOut() {
        Persistence.shared.deleteUser()
        performSegue(withIdentifier: "segueToVCWelcome", sender: nil)
    }
    
    
    //Переключение верхнего меню
    func tapToCVCell(){
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

    
    
    //MARK: - анимация верхнего меню
    
    func changeModeIntoSecondMenu(activeMode: String, categoriesID: Int) {
        print("AppSystemData.instance.activeCatalogMode888= \(AppSystemData.instance.activeCatalogMode)")
        AppSystemData.instance.activeCatalogMode = activeMode
        print("AppSystemData.instance.activeCatalogMode888_2= \(AppSystemData.instance.activeCatalogMode)")
        AppSystemData.instance.activeCatalogCategory = categoriesID
        catalogCollectionViewUpdate()
        
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
    
    
    @IBAction func cartActionButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToVCCart", sender: nil)
    }
    
    
    @IBAction func handlerButtonTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            print("buttonTapp")
            slideProfileMenuPushed(gesture: gesture, gestureView: menuButtonView, isTap: true)
        }
    }
    
    
    //Обработка горизонтального перемещения бокового меню
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
   
    
    //Закрытие слайдера с профайлом без дополнительных сценариев
    func slideSimpleClose() {
        print("slideClose")
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
            self.menuButtonView.frame.origin.x = UIScreen.main.bounds.width - self.menuButtonView.frame.size.width
            self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width
        })
    }
    
    
    //Открытие/закрытие слайдера с профайлом в зависимости от его метосположения
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
        print("332")
        if AppSystemData.instance.activeCatalogMode == "subcategories" {
            print("333")
            
            dataSourceSubcategoriesMode = makeDataSourceSubcategoriesMode()
            dataSourceCategoriesMode = makeDataSourceCategoriesMode()
            
            AppSystemData.instance.activeCatalogMode = "categories"
            buttonCategoriesGesture(nil)
            print("334")
        } else if AppSystemData.instance.activeCatalogMode == "product" {
            
            dataSourceSubcategoriesMode = makeDataSourceSubcategoriesMode()
            dataSourceProductMode = makeDataSourceProductMode()
            
            print("334")
            AppSystemData.instance.activeCatalogMode = "subcategories"
            
            switch AppSystemData.instance.activeCatalogCategory {
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
        print("335")
//        catalogCollectionViewUpdate()
//        self.view.layoutIfNeeded()
        print("AppSystemData.instance.activeCatalogMode222= \(AppSystemData.instance.activeCatalogMode)")
        print("336")
    }
    
    
    //Push "Categories" button in upper menu
    @IBAction func buttonCategoriesGesture(_ sender: Any?) {
        borderLineForSecondMenu(button: 1)
        changeModeIntoSecondMenu(activeMode: "categories", categoriesID: 0)
    }
    
    
    //Push "Mens" button in upper menu
    @IBAction func buttonMensGesture(_ sender: Any?) {
        borderLineForSecondMenu(button: 2)
        changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 0)
    }
    
    
    //Push "Womens" button in upper menu
    @IBAction func buttonWomensGesture(_ sender: Any?) {
        borderLineForSecondMenu(button: 3)
        changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 11)
    }
    
    
    //Push "Sale" button in upper menu
    @IBAction func buttonSaleGesture(_ sender: Any?) {
        borderLineForSecondMenu(button: 4)
        changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 99)
    }
    
    
    //MARK: - screen update
    
    func catalogCollectionViewUpdate() {
        applySnapshot()
        print("mainCatalogCollectionUpdate")
    }
    
    func hudAppear() {
        hud.show(in: self.view)
        print("hudAppear")
    }
    func hudDisapper() {
        hud.dismiss(animated: true)
        print("hudDisapper")
    }
    
    
    //MARK: - viewDidAppear
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        print("viewDidAppear")
//
////        AppSystemData.instance.activeCatalogMode = "categories"
////
////        print("AppSystemData.instance.VCMainCatalogDelegate_222= \(AppSystemData.instance.vcMainCatalogDelegate)")
////
////        AppSystemData.instance.vcMainCatalogDelegate = self
//
////        applySnapshot(animatingDifferences: false)
////        CatalogData.instance.requestCategoriesData()
////
////        menuButtonView.layer.cornerRadius = 8
////        menuButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
////        menuButtonView.layer.borderWidth = 0
////        menuButtonView.layer.borderColor = UIColor.clear.cgColor
////        menuButtonView.clipsToBounds = true
////
////        hud.textLabel.text = "Loading"
//
//    }
    
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
//        AppSystemData.instance.activeCatalogMode = "categories"
        CatalogData.instance.requestCategoriesData()
        applySnapshot(animatingDifferences: false)
    }

    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        AppSystemData.instance.activeCatalogMode = "categories"
//
        print("AppSystemData.instance.VCMainCatalogDelegate_222= \(AppSystemData.instance.vcMainCatalogDelegate)")
//
        AppSystemData.instance.vcMainCatalogDelegate = self
//        applySnapshot(animatingDifferences: false)
//        CatalogData.instance.requestCategoriesData()
//
        menuButtonView.layer.cornerRadius = 8
        menuButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        menuButtonView.layer.borderWidth = 0
        menuButtonView.layer.borderColor = UIColor.clear.cgColor
        menuButtonView.clipsToBounds = true

        hud.textLabel.text = "Loading"
        
        
//        print("Persistence.shared.printAllObject()_2= \(Persistence.shared.getAllObjectPersonalData())")
//        var dataName: String = ""
//        for n in Persistence.shared.getAllObjectOfFavorite() {
//            dataName += " + \(n.name)"
//            print("Favorite n.name= \(n.name)")
//            print("Favorite n= \(n)")
//        }
//        print("getAllObjectOfFavorite= \(dataName)")
        
        
//        var dataName2: String = ""
//        for n in Persistence.shared.getAllObjectOfCart() {
//            dataName2 += " + \(n.name)"
//            print("Cart n.name= \(n.name)")
//            print("Cart n= \(n)")
//        }
//        print("getAllObjectOfCart= \(dataName2)")
    }
    
}


//MARK: - additional protocols


//MARK: - Dimension of CollectionView
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


extension VCMainCatalog: VCMainCatalogProtocol {
    func updateItemInCollectionView(indexPath: IndexPath, nameGood: String) {
        catalogCollectionView.reloadItems(at: [indexPath])
        self.view.layoutIfNeeded()
        print("reloadItems, name= \(nameGood)")
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


