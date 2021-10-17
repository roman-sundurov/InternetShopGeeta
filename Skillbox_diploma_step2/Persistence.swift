//
//  Persistence.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 06.09.2021.
//

import Foundation
import RealmSwift

class VCDelegateArray {
    static let instance = VCDelegateArray()
    
    var VCMainCatalogDelegate: VCMainCatalog? = nil
    
}


class CatalogSubCategory: Object{
    @objc dynamic var id: Int = 0
    @objc dynamic var iconImage: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
}

class Persistence{
    static let shared = Persistence()
    private let realm = try! Realm()
    
//    func addCatalogCategory(name: String, sortOrder: Int, image: String, iconImage: String, iconImageActive: String) {
//        let catalogCategory = CatalogCategory()
//        catalogCategory.name = name
//        catalogCategory.sortOrder = sortOrder
//        catalogCategory.image = image
//        catalogCategory.iconImage = iconImage
//        catalogCategory.iconImageActive = iconImageActive
//        try! realm.write{
//            realm.add(catalogCategory)
//        }
//    }
    
}
