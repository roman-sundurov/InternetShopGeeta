//
//  Networking.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 20.09.2021.
//

import Foundation
import Alamofire
import UIKit

class AllCategories{
    
    static let instance = AllCategories()
    
    var categoriesArray: [CategoriesForCatalog] = []
    
    
    func showCategories() {
    
        print("start")
        print(AllCategories.instance.categoriesArray.count)
        print(AllCategories.instance.categoriesArray)
        print(AllCategories.instance.categoriesArray[0].image)
        print("finish")
    
    }
    
}


class CategoriesForCatalog {
    
    let name: String
    let sortOrder: Int
    let image: String
    let iconImage: String
    let iconImageActive: String
    let imageUIImage: UIImage?
    var goods: [GoodsOfCategory]?
    
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
        let sortOrder = data["sortOrder"] as? String,
        let image = data["image"] as? String,
        let iconImage = data["iconImage"] as? String,
        let iconImageActive = data["iconImageActive"] as? String else {
            return nil
        }
        self.name = name
        self.sortOrder = Int(sortOrder) ?? 0
        self.image = image
        self.iconImage = iconImage
        self.iconImageActive = iconImageActive
        self.imageUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(image)")!))?.trim()
    }
    
}


class Subcategories {
    
//    let keyID: String
    let id: Int
    let iconImage: String
    let sortOrder: Int
    let name: String
    let type: String
    
    init?(data: NSDictionary) {
        guard let id = data["id"] as? Int,
        let iconImage = data["iconImage"] as? String,
        let sortOrder = data["sortOrder"] as? String,
        let name = data["name"] as? String,
        let type = data["type"]  as? String else {
            return nil
        }
        self.id = id
        self.iconImage = iconImage
        self.sortOrder = sortOrder
        self.name = name
        self.typ = type
    }
    
}


class GoodsOfCategory {
    
//    let keyID: String
    let name: String
    let englishName: String
    let article: String
    let description: String
    
    init?(data: NSDictionary) {
        guard let name = data["name"] as? String,
        let englishName = data["englishName"] as? String,
        let article = data["article"] as? String,
        let description = data["description"] as? String else {
            return nil
        }
        self.name = name
        self.englishName = englishName
        self.article = article
        self.description = description
    }
    
}
