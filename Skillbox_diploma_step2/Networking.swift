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
    }
    
}
