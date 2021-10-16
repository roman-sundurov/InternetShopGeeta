//
//  Networking.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 20.09.2021.
//

import Foundation
import Alamofire
import UIKit

class CatalogData{
    
    static let instance = CatalogData()
    
    var categoriesArray: [CategoriesForCatalog] = []
    
    var activeCatalogMode: String = "catalog" // catalog/subcategories/product
    var activeCatalogCategory: Int = 0
    var activeCatalogSubCategory: Int = 0
    var activeCatalogProduct: Int = 0
    
    
    func showCategories() {
    
        print("start")
        print(CatalogData.instance.categoriesArray.count)
        print(CatalogData.instance.categoriesArray)
        print("[0].name= \(CatalogData.instance.categoriesArray[0].subCategories[0].name)")
        print("[0].id= \(CatalogData.instance.categoriesArray[0].subCategories[0].id)")
        print("finish")
    
    }
    
}


class CategoriesForCatalog {
    
    var id: Int = 0
    let name: String
    let sortOrder: Int
    let image: String
    let iconImage: String
    let iconImageActive: String
    let imageUIImage: UIImage?
    let subCategories: [SubCategories]
    
    
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
    
}


class SubCategories: Equatable {
    
    static func == (lhs: SubCategories, rhs: SubCategories) -> Bool {
        if lhs == rhs {
            return true
        } else {
            return false
        }
    }
    
    
//    let keyID: String
    let id: Int
    let iconImage: String
    let imageUIImage: UIImage?
//    let sortOrder: Int
    let name: String
//    let type: String
//    var goodsOfCategory: [GoodsOfCategory]?
    
    init?(data: NSDictionary) {
        guard let id = data["id"] as? Int ?? Int(data["id"] as! String),
        let iconImage = data["iconImage"] as? String,
        let sortOrder = data["sortOrder"] as? Int ?? Int(data["sortOrder"] as! String),
        let name = data["name"] as? String else {
//        let type = data["type"]  as? String else {
            return nil
        }
        self.id = id
        self.iconImage = iconImage
        self.imageUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(iconImage)")!))?.trim()
//        self.sortOrder = sortOrder
        self.name = name
//        self.type = type
    }
    
}


class GoodsOfCategory {
    
//    let keyID: String
    let name: String
    let englishName: String
    let article: String
    let description: String
    let mainImage: String
    let imageUIImage: UIImage?
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
        let englishName = data["englishName"] as? String,
        let article = data["article"] as? String,
        let description = data["description"] as? String,
        let mainImage = data["mainImage"] as? String else {
            return nil
        }
        self.name = name
        self.englishName = englishName
        self.article = article
        self.description = description
        self.mainImage = mainImage
        self.imageUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(mainImage)")!))?.trim()
    }
    
}
