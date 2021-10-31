//
//  Persistence.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 06.09.2021.
//

import Foundation
import RealmSwift

class AppSystemData {
    static let instance = AppSystemData()

    var VCMainCatalogDelegate: VCMainCatalog? = nil
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
            realm.delete(realm.objects(PersonalData.self))
        }
    }
    
    
    func getAllObjectPersonalData() -> Results<PersonalData> {
        try! realm.write{
            return realm.objects(PersonalData.self)
        }
    }
    
}
