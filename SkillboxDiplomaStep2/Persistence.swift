//
//  Persistence.swift
//  Skillbox_diploma_step2
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
  var activeCatalogMode: String = "categories" // catalog/subcategories/product
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
  private let realm = try! Realm()

  func activateNewUser(fullName: String, email: String, password: String) {
    print("888")
    let newUser = PersonalData()
    newUser.name = fullName
    newUser.email = email
    newUser.password = password
    try! realm.write {
      realm.add(newUser)
    }
    print("888000")
  }

  func deleteUser() {
    print("deleteUser")
    try! realm.write {
      realm.delete(realm.objects(PersonalData.self))
      realm.delete(realm.objects(PersistenceFavorite.self))
      realm.delete(realm.objects(PersistenceCart.self))
      realm.delete(realm.objects(PersistenceSize.self))
    }
  }

  func getAllObjectPersonalData() -> Results<PersonalData> {
    try! realm.write {
      return realm.objects(PersonalData.self)
    }
  }

  // Сохранение избранных товаров
  func addGoodsToFavorite(good: Products) {
    print("addGoodsToFavorite")
    let favoriteGood = PersistenceFavorite()
    favoriteGood.name = good.name
    favoriteGood.englishName = good.englishName
    favoriteGood.sortOrder = good.sortOrder
    favoriteGood.article = good.article
    favoriteGood.descriptionGoods = good.descriptionGoods
    favoriteGood.goodsImage = good.goodsImage
    favoriteGood.goodsUIImageData = good.goodsUIImage?.jpegData(compressionQuality: 1.0) as NSData?
    favoriteGood.price = good.price
    favoriteGood.inCart = good.inCart ?? false
    try! realm.write {
      realm.add(favoriteGood)
    }
  }

  // Удаление избранных товаров
  func deleteGoodsFromFavorite(article: String) {
    print("deleteGoodsToFavorite, article= \(article)")
    for object in Persistence.shared.getAllObjectOfFavorite() {
      print("article= \(object.article), name= \(object.name)")
    }
    let objectForDeleting: PersistenceFavorite? = realm
      .objects(PersistenceFavorite.self)
      .filter("article == '\(article)'")
      .first
    // print("article= \(article), objectForDeleting.article= \(objectForDeleting)")
    try! realm.write {
      realm.delete(objectForDeleting!)
    }
  }

  // Сохранение товаров корзины
  func addGoodsToCart(good: Products, size: PersistenceSize, catalog: String) {
    print("addGoodsToCart catalog= \(catalog)")
    let cartGood = PersistenceCart()
    cartGood.name = good.name
    cartGood.category = catalog
    cartGood.englishName = good.englishName
    cartGood.sortOrder = good.sortOrder
    cartGood.article = good.article
    cartGood.descriptionGoods = good.descriptionGoods
    cartGood.goodsImage = good.goodsImage
    cartGood.size = size
    cartGood.goodsUIImageData = good.goodsUIImage?.jpegData(compressionQuality: 1.0) as NSData?
    cartGood.price = good.price
    cartGood.isFavorite = good.isFavorite ?? false
    try! realm.write {
      realm.add(cartGood)
    }
  }

  // Удаление товаров корзины
  func deleteGoodsFromCart(article: String) {
    print("deleteGoodsToCart, article= \(article)")
    for object in Persistence.shared.getAllObjectOfCart() {
      // print("article= \(object.article), name= \(object.name)")
    }
    let objectForDeleting: PersistenceCart? = realm
      .objects(PersistenceCart.self)
      .filter("article == '\(article)'")
      .first
    print("article= \(article), objectForDeleting.article= \(objectForDeleting)")
    try! realm.write {
      // print("deleteGoodsToCart2, article= \(article)")
      realm.delete(objectForDeleting!)
    }
  }

  func getAllObjectOfFavorite() -> Results<PersistenceFavorite> {
    let allFavoriteGoods = realm.objects(PersistenceFavorite.self)
    return allFavoriteGoods
  }

  func getAllObjectOfCart() -> Results<PersistenceCart> {
    let allCartGoods = realm.objects(PersistenceCart.self)
    print("getAllObjectOfCart, allCartGoods.count= \(allCartGoods.count)")
    return allCartGoods
  }

  func newInstanceSizeOfGoode(size: Size) -> PersistenceSize {
    let cartGood = PersistenceSize()
    cartGood.sSize = size.sSize
    cartGood.mSize = size.mSize
    cartGood.lSize = size.lSize
    cartGood.xlSize = size.xlSize
    cartGood.xxlSize = size.xxlSize
    return cartGood
  }
}
