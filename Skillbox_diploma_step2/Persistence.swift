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

    var vcMainCatalogDelegate: VCMainCatalog?
    var vcCartDelegate: VCCart?
    var activeCatalogMode: String = "catalog" // catalog/subcategories/product
    var activeCatalogCategory: Int = 0
    var activeCatalogSubCategory: Int = 0
    var activeCatalogProduct: Int = 0
}


class PersonalData: Object {
    static let instance = PersonalData()
    
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
//    var cart = List<CartGoods>()
    var favorite = List<FavoriteGoods>()
    var cart = List<CartGoods>()
}


class FavoriteGoods: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var englishName: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var article: String = ""
    @objc dynamic var descriptionGoods: String = ""
    @objc dynamic var goodsImage: String = ""
    @objc dynamic var goodsUIImageData: NSData? = nil
    @objc dynamic var price: Double = 0
    @objc dynamic var inCart: Bool = false
}


class CartGoods: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var englishName: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var article: String = ""
    @objc dynamic var descriptionGoods: String = ""
    @objc dynamic var goodsImage: String = ""
    @objc dynamic var goodsUIImageData: NSData? = nil
    @objc dynamic var price: Double = 0
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var size: SizeOfGood? = SizeOfGood()
}


class SizeOfGood: Object {
    @objc dynamic var sSize: Bool = false
    @objc dynamic var mSize: Bool = false
    @objc dynamic var lSize: Bool = false
    @objc dynamic var xlSize: Bool = false
    @objc dynamic var xxlSize: Bool = false
    
//    init(sSize: Bool, mSize: Bool, lSize: Bool, xlSize: Bool, xxlSize: Bool) {
//        self.sSize = sSize
//        self.mSize = mSize
//        self.lSize = lSize
//        self.xlSize = xlSize
//        self.xxlSize = xxlSize
//    }
}


class Persistence{
    static let shared = Persistence()
    private let realm = try! Realm()
    
    
    func activateNewUser(fullName: String, email: String, password: String) {
        print("888")
        let newUser = PersonalData()
        newUser.name = fullName
        newUser.email = email
        newUser.password = password
        try! realm.write{
            realm.add(newUser)
        }
        print("888000")
    }
    
    
    func deleteUser() {
        print("deleteUser")
        try! realm.write{
//            realm.delete(realm.objects(AppSystemData.self))
            realm.delete(realm.objects(PersonalData.self))
            realm.delete(realm.objects(FavoriteGoods.self))
            realm.delete(realm.objects(CartGoods.self))
            realm.delete(realm.objects(SizeOfGood.self))
        }
    }
    
    
    func getAllObjectPersonalData() -> Results<PersonalData> {
        try! realm.write{
            return realm.objects(PersonalData.self)
        }
    }
    
    
    //Сохранение избранных товаров
    func addGoodsToFavorite(good: GoodsOfCategory) {
        print("addGoodsToFavorite")
        let favoriteGood = FavoriteGoods()
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
    
    //Удаление избранных товаров
    func deleteGoodsFromFavorite(article: String) {
        print("deleteGoodsToFavorite, article= \(article)")
        for n in Persistence.shared.getAllObjectOfFavorite() {
            print("article= \(n.article), name= \(n.name)")
        }
        let objectForDeleting: FavoriteGoods? = realm.objects(FavoriteGoods.self).filter("article == '\(article)'").first
        print("article= \(article), objectForDeleting.article= \(objectForDeleting)")
        try! realm.write {
            realm.delete(objectForDeleting!)
        }
    }


    //Сохранение товаров корзины
    func addGoodsToCart(good: GoodsOfCategory, size: SizeOfGood, catalog: String) {
        print("addGoodsToCart")
        let cartGood = CartGoods()
        cartGood.name = good.name
        cartGood.name = catalog
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
    
    //Удаление товаров корзины
    func deleteGoodsFromCart(article: String) {
        print("deleteGoodsToCart, article= \(article)")
        for n in Persistence.shared.getAllObjectOfCart() {
            print("article= \(n.article), name= \(n.name)")
        }
        let objectForDeleting: CartGoods? = realm.objects(CartGoods.self).filter("article == '\(article)'").first
        print("article= \(article), objectForDeleting.article= \(objectForDeleting)")
        try! realm.write {
            realm.delete(objectForDeleting!)
        }
    }


    func getAllObjectOfFavorite() -> Results<FavoriteGoods> {
        let allFavoriteGoods = realm.objects(FavoriteGoods.self)
            return allFavoriteGoods
    }
    
    
    func getAllObjectOfCart() -> Results<CartGoods> {
        let allCartGoods = realm.objects(CartGoods.self)
            return allCartGoods
    }
    
}


