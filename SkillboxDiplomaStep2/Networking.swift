  //
  //  Networking.swift
  //  Skillbox_diploma_step2
  //
  //  Created by Roman on 20.09.2021.
  //

  import Foundation
  import Alamofire
  import UIKit
import RealmSwift


  // MARK: - class CatalogData
  class CatalogData {
    static let instance = CatalogData()
    private var categoriesArray: [Categories] = []
    var cartCategoriesAndProductsDiffableArray: [CartCategoriesAndProductsDiffable] = []
  }

  extension CatalogData {
    func getCategoriesArray() -> [Categories] {
      return categoriesArray
    }

    func setCategoriesArray(newArray: [Categories]) {
      categoriesArray = newArray
    }

    func getSubcategoriesData() -> [NSDictionary] {
      let categoriesArray = CatalogData.instance.getCategoriesArray()
      let tempA: Int = categoriesArray.firstIndex {
        $0.sortOrder == AppSystemData.instance.activeCatalogCategory
      }!
      return categoriesArray[tempA].subCategoriesData
    }

    func setSubcategoriesArray(newArray: [SubCategories]) {
      // DispatchQueue.global(qos: .userInitiated).sync(flags: .barrier) {
        let categoriesArray = CatalogData.instance.getCategoriesArray()
        let tempA: Int = categoriesArray.firstIndex {
          $0.sortOrder == AppSystemData.instance.activeCatalogCategory
        }!
        categoriesArray[tempA].subCategories = newArray
      // }
    }
  }


  // MARK: - class CatalogsAndProductsDiffable
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

  // MARK: - class Cart
  class Cart: Hashable {
    var name: String = ""
    var catalog: String = ""
    var englishName: String = ""
    var sortOrder: Int = 0
    var article: String = ""
    var descriptionGoods: String = ""
    var goodsImage: String = ""
    var goodsUIImageData: NSData?
    var price: Double = 0
    var isFavorite = false
    var size = PersistenceSize()

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


  // MARK: - class Categories
  class Categories: Hashable {
    let name: String
    let sortOrder: Int
    let image: String
    let iconImage: String
    let iconImageActive: String
    let imageUIImage: UIImage?
    let subCategoriesData: [NSDictionary]
    var subCategories: [SubCategories]

    init?(data: NSDictionary) {
      if (data["image"] as? String)?.isEmpty == true || (data["subcategories"] as? [NSDictionary])?.isEmpty == true {
        return nil
      }
      print("Categories init")
      guard let name = data["name"] as? String,
      let sortOrder = data["sortOrder"] as? String,
      let image = data["image"] as? String,
      let iconImage = data["iconImage"] as? String,
      let iconImageActive = data["iconImageActive"] as? String,
      let subCategoriesData = data["subcategories"] as? [NSDictionary] else {
        return nil
      }
      self.name = name
      self.sortOrder = Int(sortOrder) ?? 0
      self.image = image
      self.iconImage = iconImage
      self.iconImageActive = iconImageActive
      self.imageUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(image)")!))?.trim()
      self.subCategoriesData = subCategoriesData
      self.subCategories = []
    }

    static func == (lhs: Categories, rhs: Categories) -> Bool {
      lhs.sortOrder == rhs.sortOrder
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(sortOrder)
    }
  }


  // MARK: - class SubCategories
  class SubCategories: Equatable, Hashable {
    static func == (lhs: SubCategories, rhs: SubCategories) -> Bool { return lhs == rhs }

    let id: Int
    let iconImage: String
    let iconUIImage: UIImage?
    let name: String
    var goodsOfCategory: [Products] = []

    init?(data: NSDictionary) {
      if (data["iconImage"] as? String)?.isEmpty == true {
        return nil
      }
      print("Subategories init")
      guard let id = data["id"] as? Int ?? Int(data["id"] as! String),
      let iconImage = data["iconImage"] as? String,
      let name = data["name"] as? String else {
        return nil
      }
      self.id = id
      self.iconImage = iconImage
      self.iconUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(iconImage)")!))?.trim()
      self.name = name
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
  }


class Size {
  var sSize = false
  var mSize = false
  var lSize = false
  var xlSize = false
  var xxlSize = false

  init?(sSize: Bool, mSize: Bool, lSize: Bool, xlSize: Bool, xxlSize: Bool) {
    self.sSize = sSize
    self.mSize = mSize
    self.lSize = lSize
    self.xlSize = xlSize
    self.xxlSize = xxlSize
  }
}


  // MARK: - class Products

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
      // print("mainImage= \(data["mainImage"] as? String)")
      // print("mainImage= \(data["englishName"] as? String)")
      if (data["mainImage"] as? String)?.isEmpty == true {
        print("Product init return nil")
        return nil
      }

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
      // Проверка, имеется ли данный артикул в Realm в Избранном или в корзине.
      DispatchQueue.main.async {
        self.isFavorite = !Persistence.shared.getAllObjectOfFavorite().filter("article == '\(article)'").isEmpty
        self.inCart = !Persistence.shared.getAllObjectOfCart().filter("article == '\(article)'").isEmpty
      }
      if self.inCart == true {
        let persistenceSize = Persistence.shared.getAllObjectOfCart().filter("article == '\(article)'").first?.size
        self.sizeInCart = Size.init(
          sSize: persistenceSize!.sSize,
          mSize: persistenceSize!.mSize,
          lSize: persistenceSize!.lSize,
          xlSize: persistenceSize!.xlSize,
          xxlSize: persistenceSize!.xxlSize
        )
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


  // MARK: - extension CatalogData
  extension CatalogData {
    func requestCategoriesData() {
      DispatchQueue.main.async {
        AppSystemData.instance.vcMainCatalogDelegate!.hudAppear()
      }
      guard AppSystemData.instance.activeCatalogMode != "product" else {
        return
      }
      var categories: [Categories] = []
      let request = AF.request("https://blackstarshop.ru/index.php?route=api/v1/categories")
      request.responseJSON { response in
        if let object = response.value, let jsonDict = object as? NSDictionary {
          let findCategoriesInData = DispatchWorkItem {
            for ( _, data) in jsonDict where data is NSDictionary {
              print("TAKT_1")
              if let category = Categories(data: data as! NSDictionary) {
                categories.append(category)
              }
              CatalogData.instance.setCategoriesArray(newArray: categories)
              DispatchQueue.main.async {
                AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionViewUpdate()
              }
            }
          }

          findCategoriesInData.notify(queue: .main) {
            AppSystemData.instance.vcMainCatalogDelegate!.hudDisapper()
          }

          DispatchQueue.global(qos: .userInitiated).async(execute: findCategoriesInData)
        }
      }
    }

    func requestSubcategoriesData() {
      print("requestSubcategoriesData")
      var subcategories: [SubCategories] = []

      DispatchQueue.main.async {
        AppSystemData.instance.vcMainCatalogDelegate!.hudAppear()
      }
      guard AppSystemData.instance.activeCatalogMode != "subcategories" else {
        print("Strange activeCatalogMode == 'subcategories'")
        return
      }

      let findSubcategoriesInData = DispatchWorkItem {
        let object = CatalogData.instance.getSubcategoriesData()
        for data in object {
          print("TAKT_2")
          if let subCategories2 = SubCategories(data: data) {
            subcategories.append(subCategories2)
            print("subCategories2.name= \(subCategories2.name)")
          }
          CatalogData.instance.setSubcategoriesArray(newArray: subcategories)
          DispatchQueue.main.async {
            AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionViewUpdate()
          }
        }
        //
      }

      findSubcategoriesInData.notify(queue: .main) {
        AppSystemData.instance.vcMainCatalogDelegate!.hudDisapper()
      }

      DispatchQueue.global(qos: .userInitiated).async(execute: findSubcategoriesInData)
    }


    func requestGoodsData() {
      DispatchQueue.main.async {
        AppSystemData.instance.vcMainCatalogDelegate!.hudAppear()
      }
      let idOfCategory = AppSystemData.instance.activeCatalogCategory
      let idOfSubCategory = AppSystemData.instance.activeCatalogSubCategory
      let categoriesArray = CatalogData.instance.getCategoriesArray()
      let tempA: Int = categoriesArray.firstIndex {
        $0.sortOrder == idOfCategory
      }!
      let tempB: Int = categoriesArray[tempA].subCategories.firstIndex {
        $0.id == AppSystemData.instance.activeCatalogSubCategory
      }!

      var goods: [Products] = []
      let request = AF.request("https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(idOfSubCategory)")
      request.responseJSON { response in
        if let object = response.value, let jsonDict = object as? NSDictionary {
          let findProductsInData = DispatchWorkItem {
            for (index, data) in jsonDict where data is NSDictionary {
              print("TAKT_3")
              print("DispatchQueue.current222= \(OperationQueue.current?.underlyingQueue)")
              if let product = Products(data: data as! NSDictionary) {
                print("99999")
                // if product.goodsImage.isEmpty == false {
                  goods.append(product)
                  print("\(product) is add to goods")
                // }
              }
              categoriesArray[tempA].subCategories[tempB].goodsOfCategory = goods
              DispatchQueue.main.async {
                AppSystemData.instance.vcMainCatalogDelegate!.catalogCollectionViewUpdate()
              }
            }
          }

          findProductsInData.notify(queue: .main) {
            AppSystemData.instance.vcMainCatalogDelegate!.hudDisapper()
          }

          DispatchQueue.global(qos: .userInitiated).async(execute: findProductsInData)
        }
      }
      print("goods2= \(goods)")
    }

    func isCategoryContain(category: String, place: [CartCategoriesAndProductsDiffable]) -> Int {
      var result: Int = -1
      var checker: Int = 0

      for data in place {
        if data.category == category {
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
          let id = isCategoryContain(
            category: persistenceCartGood.category,
            place: cartCategoriesAndProductsDiffableArray)

          if id >= 0 {
            print("updateCatalogsAndCartGoodsDiffableArray id != 0, \(persistenceCartGood.category)")
            cartCategoriesAndProductsDiffableArray[id].cartGoodsDiffable.append(Cart.init(
              name: persistenceCartGood.name,
              catalog: persistenceCartGood.category,
              englishName: persistenceCartGood.englishName,
              sortOrder: persistenceCartGood.sortOrder,
              article: persistenceCartGood.article,
              descriptionGoods: persistenceCartGood.description,
              goodsImage: persistenceCartGood.goodsImage,
              goodsUIImageData: persistenceCartGood.goodsUIImageData,
              price: persistenceCartGood.price,
              isFavorite: persistenceCartGood.isFavorite,
              size: persistenceCartGood.size!
            ))
          } else {
            print("updateCatalogsAndCartGoodsDiffableArray id == 0, \(persistenceCartGood.category)")
            cartCategoriesAndProductsDiffableArray.append(CartCategoriesAndProductsDiffable.init(
              catalog: persistenceCartGood.category,
              cartGoods: [
                Cart.init(
                  name: persistenceCartGood.name,
                  catalog: persistenceCartGood.category,
                  englishName: persistenceCartGood.englishName,
                  sortOrder: persistenceCartGood.sortOrder,
                  article: persistenceCartGood.article,
                  descriptionGoods: persistenceCartGood.description,
                  goodsImage: persistenceCartGood.goodsImage,
                  goodsUIImageData: persistenceCartGood.goodsUIImageData,
                  price: persistenceCartGood.price,
                  isFavorite: persistenceCartGood.isFavorite,
                  size: persistenceCartGood.size!
                )
              ]
            ))
          }
        } else {
          print("updateCatalogsAndCartGoodsDiffableArray emptyArray, \(persistenceCartGood.category)")
          cartCategoriesAndProductsDiffableArray.append(CartCategoriesAndProductsDiffable.init(
            catalog: persistenceCartGood.category,
            cartGoods: [
              Cart.init(
                name: persistenceCartGood.name,
                catalog: persistenceCartGood.category,
                englishName: persistenceCartGood.englishName,
                sortOrder: persistenceCartGood.sortOrder,
                article: persistenceCartGood.article,
                descriptionGoods: persistenceCartGood.description,
                goodsImage: persistenceCartGood.goodsImage,
                goodsUIImageData: persistenceCartGood.goodsUIImageData,
                price: persistenceCartGood.price,
                isFavorite: persistenceCartGood.isFavorite,
                size: persistenceCartGood.size!
              )
            ]
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
  }
