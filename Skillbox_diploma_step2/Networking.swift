//
//  Networking.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 20.09.2021.
//

import Foundation
import Alamofire
//import RealmSwift
import UIKit


//MARK: - class CatalogData
class CatalogData{
    
    static let instance = CatalogData()
    
    var categoriesArray: [Categories] = []
    var cartCategoriesAndProductsDiffableArray: [CartCategoriesAndProductsDiffable] = []
    
}


//MARK: - class CatalogsAndProductsDiffable
class CartCategoriesAndProductsDiffable: Hashable {
    var id = UUID()
    
    var category: String
    var cartGoodsDiffable: [Cart]
    
    init(catalog: String, cartGoods: [Cart]) {
        self.category = catalog
        self.cartGoodsDiffable = cartGoods
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: CartCategoriesAndProductsDiffable, rhs: CartCategoriesAndProductsDiffable) -> Bool {
      lhs.id == rhs.id
    }
    
}

//MARK: - class Cart
class Cart: Hashable {
    var name: String = ""
    var catalog: String = ""
    var englishName: String = ""
    var sortOrder: Int = 0
    var article: String = ""
    var descriptionGoods: String = ""
    var goodsImage: String = ""
    var goodsUIImageData: NSData? = nil
    var price: Double = 0
    var isFavorite: Bool = false
    var size: PersistenceSize = PersistenceSize()
    
    init(name: String, catalog: String, englishName: String, sortOrder: Int, article: String, descriptionGoods: String, goodsImage: String, goodsUIImageData: NSData?, price: Double, isFavorite: Bool, size: PersistenceSize) {
        self.name = name
        self.catalog = catalog
        self.englishName = englishName
        self.sortOrder = sortOrder
        self.article = article
        self.descriptionGoods = descriptionGoods
        self.goodsImage = goodsImage
        self.goodsUIImageData = goodsUIImageData
        self.price = price
        self.isFavorite = isFavorite
        self.size = size
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(sortOrder)
    }
    
    static func == (lhs: Cart, rhs: Cart) -> Bool {
      lhs.sortOrder == rhs.sortOrder
    }

}


//MARK: - class Categories
class Categories: Hashable {
    
    let name: String
    let sortOrder: Int
    let image: String
    let iconImage: String
    let iconImageActive: String
    let imageUIImage: UIImage?
    var subCategories: [SubCategories]
    
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
        let sortOrder = data["sortOrder"] as? String,
        let image = data["image"] as? String,
        let iconImage = data["iconImage"] as? String,
        let iconImageActive = data["iconImageActive"] as? String,
        let subCategories = data["subcategories"] as? [NSDictionary] else {
            return nil
        }
        self.name = name
        self.sortOrder = Int(sortOrder) ?? 0
        self.image = image
        self.iconImage = iconImage
        self.iconImageActive = iconImageActive
        self.imageUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(image)")!))?.trim()
        var subCategories2: [SubCategories] = []
        for value in subCategories {
            if let subCategories3 = SubCategories(data: value) {
                subCategories2.append(subCategories3)
//                print("subCategories3= \(subCategories3.name)")
            }
        }
        self.subCategories = subCategories2
        
    }
    
    static func == (lhs: Categories, rhs: Categories) -> Bool {
        lhs.sortOrder == rhs.sortOrder
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(sortOrder)
    }
    
}


//MARK: - class SubCategories
class SubCategories: Equatable, Hashable {
    
    static func == (lhs: SubCategories, rhs: SubCategories) -> Bool { return lhs == rhs }
    
    let id: Int
    let iconImage: String
    let iconUIImage: UIImage?
    let name: String
    var goodsOfCategory: [Products] = []
    
    init?(data: NSDictionary) {
        guard let id = data["id"] as? Int ?? Int(data["id"] as! String),
        let iconImage = data["iconImage"] as? String,
//        let sortOrder = data["sortOrder"] as? Int ?? Int(data["sortOrder"] as! String),
        let name = data["name"] as? String else {
            return nil
        }
        self.id = id
        self.iconImage = iconImage
        self.iconUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(iconImage)")!))?.trim()
        self.name = name
//        self.goodsOfCategory = CatalogData.instance.requestGoodsData(idOfSubCategory: self.id)
    }
    
    
//    static func == (lhs: SubCategories, rhs: SubCategories) -> Bool {
//        lhs.id == rhs.id
//    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    
}


//MARK: - class Products

class Size {
    var sSize: Bool = false
    var mSize: Bool = false
    var lSize: Bool = false
    var xlSize: Bool = false
    var xxlSize: Bool = false
    
        init?(sSize: Bool, mSize: Bool, lSize: Bool, xlSize: Bool, xxlSize: Bool) {
            self.sSize = sSize
            self.mSize = mSize
            self.lSize = lSize
            self.xlSize = xlSize
            self.xxlSize = xxlSize
        }
    
}

class Products: Hashable {
    var id = UUID()
    
    let name: String
    let englishName: String
    let sortOrder: Int
    let article: String
    let descriptionGoods: String
    let goodsImage: String
    let goodsUIImage: UIImage?
    let price: Double
    var isFavorite: Bool?
    var inCart: Bool?
    var sizeInCart: Size?
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
            let englishName = data["englishName"] as? String,
              let sortOrder = data["sortOrder"] as? String,
              let article = data["article"] as? String,
              let description = data["description"] as? String,
              let price = data["price"] as? Double ?? Double(data["price"] as! String),
              let mainImage = data["mainImage"] as? String else {
                  return nil
              }
        self.name = name
        self.englishName = englishName
        self.sortOrder = Int(sortOrder) ?? 0
        self.article = article
        self.descriptionGoods = description
        print("Special Price= \(price)")
        self.price = price
        self.goodsImage = mainImage
        self.goodsUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(mainImage)")!))?.trim()
        //Проверка, имеется ли данный артикул в Realm в Избранном или в корзине.
        self.isFavorite = !Persistence.shared.getAllObjectOfFavorite().filter("article == '\(article)'").isEmpty
        self.inCart = !Persistence.shared.getAllObjectOfCart().filter("article == '\(article)'").isEmpty
        if self.inCart == true {
            let persistenceSize = Persistence.shared.getAllObjectOfCart().filter("article == '\(article)'").first?.size
            self.sizeInCart = Size.init(sSize: persistenceSize!.sSize, mSize: persistenceSize!.mSize, lSize: persistenceSize!.lSize, xlSize: persistenceSize!.xlSize, xxlSize: persistenceSize!.xxlSize)
        } else {
            self.sizeInCart = Size.init(sSize: false, mSize: false, lSize: false, xlSize: false, xxlSize: false)
        }
    }
    
    
        static func == (lhs: Products, rhs: Products) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
          hasher.combine(id)
        }
    
}


//MARK: - extension CatalogData
extension CatalogData {
    
    
    func requestCategoriesData() {
        guard AppSystemData.instance.activeCatalogMode != "product" else {
            return
        }
        var categories: [Categories] = []
        let request = AF.request("https://blackstarshop.ru/index.php?route=api/v1/categories")
        AppSystemData.instance.vcMainCatalogDelegate!.hudAppear()
        request.responseJSON(completionHandler: { response in
            if let object = response.value, let jsonDict = object as? NSDictionary {
//                print("jsonDict= \(jsonDict)")
                    for (index, data) in jsonDict where data is NSDictionary{
//                            print("index= \(index)")
                        if let category = Categories(data: data as! NSDictionary) {
//                            print("111")
                            if category.image != "" && category.subCategories != [] {
                                category.subCategories.removeAll{ value in return value.iconImage == ""}
//                                category.id = index as? Int ?? Int(index as! String) ?? 0
                                categories.append(category)
//                                print("\(category.id)")
                            }
                        }
                        CatalogData.instance.categoriesArray = categories
                        print("categories.count111= \(categories.count)")
                        AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionViewUpdate()
                    }
                CatalogData.instance.categoriesArray = categories
                print("categories.count222= \(categories.count)")
                CatalogData.instance.showCategories()
                
                print("AppSystemData.instance.VCMainCatalogDelegate_333= \(AppSystemData.instance.vcMainCatalogDelegate)")
                
//                AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionViewUpdate()
                AppSystemData.instance.vcMainCatalogDelegate!.hudDisapper()
//                CatalogData.instance.requestGoodsData()
                AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionViewUpdate()
                print("categories888= \(categories)")
                }
            })
    }
    
    
    func requestGoodsData() {
        let idOfCategory = AppSystemData.instance.activeCatalogCategory
        let idOfSubCategory = AppSystemData.instance.activeCatalogSubCategory
//        print("idOfSubCategory= \(idOfSubCategory)")
        let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == idOfCategory })!
        let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppSystemData.instance.activeCatalogSubCategory })!
        print("111_idOfCategory= \(idOfCategory)")
        print("111_idOfSubCategory= \(idOfSubCategory)")
        print("111_activeCatalogCategory= \(AppSystemData.instance.activeCatalogCategory)")
        print("111_activeCatalogSubCategory= \(AppSystemData.instance.activeCatalogSubCategory)")
        print("222_subcategoryname = \(CatalogData.instance.categoriesArray[tempA].subCategories[tempB].name)")
        
        var goods: [Products] = []
        let request = AF.request("https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(idOfSubCategory)")
        AppSystemData.instance.vcMainCatalogDelegate!.hudAppear()
        request.responseJSON(completionHandler: { response in
            if let object = response.value, let jsonDict = object as? NSDictionary {
//                print("jsonDict= \(jsonDict)")
                    for (index, data) in jsonDict where data is NSDictionary{
                            print("index= \(index)")
                        if let product = Products(data: data as! NSDictionary) {
                            print("777")
                            if product.goodsImage != "" {
                                goods.append(product)
                                print("\(product) is add to goods")
                            }
                        }
                    }
                print("goods1= \(goods)")
                print("jsonDict.count= \(jsonDict.count)")
                print("goods.count= \(goods.count)")
                CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory = goods
                AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionViewUpdate()
                AppSystemData.instance.vcMainCatalogDelegate!.hudDisapper()
                }
            })
        print("goods2= \(goods)")
    }

    
    func showCategories() {
        print("start")
        print(CatalogData.instance.categoriesArray.count)
        print(CatalogData.instance.categoriesArray)
        print("[0].name= \(CatalogData.instance.categoriesArray[0].subCategories[0].name)")
        print("[0].id= \(CatalogData.instance.categoriesArray[0].subCategories[0].id)")
        print("finish")
    }
    
    
    func isCategoryContain(category: String, place: [CartCategoriesAndProductsDiffable]) -> Int {
        var result: Int = -1
        var checker: Int = 0
        
        for n in place {
            if n.category == category {
                result = checker
                break
            }
            checker += 1
        }

        return result
    }
    
    
    func updateCatalogsAndCartGoodsDiffableArray() {
        print("updateCatalogsAndCartGoodsDiffable")
        cartCategoriesAndProductsDiffableArray = []
        
        for persistenceCartGood in Persistence.shared.getAllObjectOfCart() {
            if cartCategoriesAndProductsDiffableArray.isEmpty == false {
                
                var id = isCategoryContain(category: persistenceCartGood.category, place: cartCategoriesAndProductsDiffableArray)
                
                if id >= 0 {
                    print("updateCatalogsAndCartGoodsDiffableArray id != 0, \(persistenceCartGood.category)")
                    cartCategoriesAndProductsDiffableArray[id].cartGoodsDiffable.append(Cart.init(name: persistenceCartGood.name, catalog: persistenceCartGood.category, englishName: persistenceCartGood.englishName, sortOrder: persistenceCartGood.sortOrder, article: persistenceCartGood.article, descriptionGoods: persistenceCartGood.description, goodsImage: persistenceCartGood.goodsImage, goodsUIImageData: persistenceCartGood.goodsUIImageData, price: persistenceCartGood.price, isFavorite: persistenceCartGood.isFavorite, size: persistenceCartGood.size!))
                } else {
                    print("updateCatalogsAndCartGoodsDiffableArray id == 0, \(persistenceCartGood.category)")
                    cartCategoriesAndProductsDiffableArray.append(CartCategoriesAndProductsDiffable.init(
                        catalog: persistenceCartGood.category,
                        cartGoods: [Cart.init(name: persistenceCartGood.name, catalog: persistenceCartGood.category, englishName: persistenceCartGood.englishName, sortOrder: persistenceCartGood.sortOrder, article: persistenceCartGood.article, descriptionGoods: persistenceCartGood.description, goodsImage: persistenceCartGood.goodsImage, goodsUIImageData: persistenceCartGood.goodsUIImageData, price: persistenceCartGood.price, isFavorite: persistenceCartGood.isFavorite, size: persistenceCartGood.size!)]
                    ))

                }
            } else {
                print("updateCatalogsAndCartGoodsDiffableArray emptyArray, \(persistenceCartGood.category)")
                cartCategoriesAndProductsDiffableArray.append(CartCategoriesAndProductsDiffable.init(
                    catalog: persistenceCartGood.category,
                    cartGoods: [Cart.init(name: persistenceCartGood.name, catalog: persistenceCartGood.category, englishName: persistenceCartGood.englishName, sortOrder: persistenceCartGood.sortOrder, article: persistenceCartGood.article, descriptionGoods: persistenceCartGood.description, goodsImage: persistenceCartGood.goodsImage, goodsUIImageData: persistenceCartGood.goodsUIImageData, price: persistenceCartGood.price, isFavorite: persistenceCartGood.isFavorite, size: persistenceCartGood.size!)]
                ))
            }
            
        }
        
    }
    
    
    func getAllCatalogsAndCartGoodsDiffable() -> [CartCategoriesAndProductsDiffable] {
        print("getAllCatalogsAndCartGoodsDiffable1= \(cartCategoriesAndProductsDiffableArray)")
        updateCatalogsAndCartGoodsDiffableArray()
        print("getAllCatalogsAndCartGoodsDiffable2= \(cartCategoriesAndProductsDiffableArray)")
        return cartCategoriesAndProductsDiffableArray
    }
    
    
//    func getAllExistCategoriesForCatalog() -> [Categories] {
////        print("getAllCategoriesForCatalog= \(catalogsAndCartGoodsDiffableArray)")
//        print("categoriesArray888= \(categoriesArray)")
//        return categoriesArray
//    }

    
}
