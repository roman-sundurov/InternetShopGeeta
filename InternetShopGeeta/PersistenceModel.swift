//
//  Persistence.swift
//  InternetShopGeeta
//
//  Created by Roman on 06.09.2021.
//

import Foundation
import RealmSwift
import UIKit

class AppSystemData {
  static let instance = AppSystemData()
  private init() {}
  var vcMainCatalogDelegate: VCMainCatalog?
  var vcCartDelegate: VCCart?
  var activeCatalogMode: String = "categories"
  var activeCatalogCategory: Int = 0
  var activeCatalogSubCategory: Int = 0
  var activeCatalogProduct: Int = 0
}

class PersonalData: Object {
  static let instance = PersonalData()
  @objc dynamic var name: String = ""
  @objc dynamic var email: String = ""
  @objc dynamic var password: String = ""
  var favorite = List<PersistenceFavorite>()
  var cart = List<PersistenceCart>()
}

class PersistenceFavorite: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var englishName: String = ""
  @objc dynamic var sortOrder: Int = 0
  @objc dynamic var article: String = ""
  @objc dynamic var descriptionGoods: String = ""
  @objc dynamic var goodsImage: String = ""
  @objc dynamic var goodsUIImageData: NSData?
  @objc dynamic var price: Double = 0
  @objc dynamic var inCart = false // Bool
}

class PersistenceCart: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var category: String = ""
  @objc dynamic var englishName: String = ""
  @objc dynamic var sortOrder: Int = 0
  @objc dynamic var article: String = ""
  @objc dynamic var descriptionGoods: String = ""
  @objc dynamic var goodsImage: String = ""
  @objc dynamic var goodsUIImageData: NSData?
  @objc dynamic var price: Double = 0
  @objc dynamic var isFavorite = false // Bool
  @objc dynamic var size: PersistenceSize? = PersistenceSize()
}

class PersistenceSize: Object {
  @objc dynamic var sSize = false
  @objc dynamic var mSize = false
  @objc dynamic var lSize = false
  @objc dynamic var xlSize = false
  @objc dynamic var xxlSize = false
}

class Persistence {
  static let shared = Persistence()
  let realm = try! Realm()
}


// MARK: - class CatalogData
class CatalogData {
  static let instance = CatalogData()
  static let requestCategoriesPath = "https://blackstarshop.ru/index.php?route=api/v1/categories"
  var categoriesArray: [Categories] = []
  var cartCategoriesAndProductsDiffableArray: [CartCategoriesAndProductsDiffable] = []
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
    // print("Subategories init")
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
    Task {
      await MainActor.run {
        self.isFavorite = !Persistence.shared.getAllObjectOfFavorite().filter("article == '\(article)'").isEmpty
        self.inCart = !Persistence.shared.getAllObjectOfCart().filter("article == '\(article)'").isEmpty
      }
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
