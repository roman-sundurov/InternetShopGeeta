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

    var VCMainCatalogDelegate: VCMainCatalog?
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
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var inCart: Bool = false
}


//class CartGoods: Object {
//}


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
            realm.delete(realm.objects(PersonalData.self))
        }
    }
    
    
    func getAllObjectPersonalData() -> Results<PersonalData> {
        try! realm.write{
            return realm.objects(PersonalData.self)
        }
    }
    
    
    //Сохранение/удаление избранных товаров
    func addGoodsToFavorite(good: GoodsOfCategory) {
        print("addGoodsToFavorite")
        let favoriteGood = FavoriteGoods()
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



//    //Сохранение/удаление товаров корзины
//    func addGoodsToCart(good: CartGoods) {
//        try! realm.write {
//            realm.add(good)
//        }
//    }
//
//    func deleteGoodsFromCar(article: String) {
//        let objectForDeleting = realm.objects(PersonalData.self).first!.cart.filter("article == \(article)")
//        try! realm.write {
//            realm.delete(objectForDeleting)
//        }
//    }



//    func getAllObjectOfCart() -> Results<CartGoods> {
//        try! realm.write{
//            return realm.objects(CartGoods.self)
//        }
//    }


    func getAllObjectOfFavorite() -> Results<FavoriteGoods> {
        let allFavoriteGoods = realm.objects(FavoriteGoods.self)
            return allFavoriteGoods
    }
    
}


