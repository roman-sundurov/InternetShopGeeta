//
//  Persistence.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 06.09.2021.
//

import Foundation
import RealmSwift

class AppActualData {
    static let instance = AppActualData()
    
    var VCMainCatalogDelegate: VCMainCatalog? = nil
    var activeCatalogMode: String = "catalog" // catalog/subcategories/product
    var activeCatalogCategory: Int = 0
    var activeCatalogSubCategory: Int = 0
    var activeCatalogProduct: Int = 0
    var actualUser: PersonalData?
    
    func setActualUser(userEmail: String) {
        let particularUser = try! Realm().objects(PersonalData.self).filter("email == \(userEmail)")
        print("particularUser= \(particularUser)")
        actualUser = particularUser as? PersonalData
    }
    
    func getActualUser() -> PersonalData? {
        return actualUser
    }

    
}


class PersonalData: Object {
    @objc dynamic var fullName: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
}


class Persistence{
    static let shared = Persistence()
    private let realm = try! Realm()
    
    func addNewUser(fullName: String, email: String, password: String) {
        let newUser = PersonalData()
        newUser.fullName = fullName
        newUser.email = email
        newUser.password = password
        try! realm.write{
            realm.add(newUser)
        }
    }
    
}
