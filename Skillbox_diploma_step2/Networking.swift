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
    var subCategories: [SubCategories]
    
    
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
    
    static func == (lhs: SubCategories, rhs: SubCategories) -> Bool { return lhs == rhs }
    
    
    let id: Int
    let iconImage: String
    let iconUIImage: UIImage?
    let name: String
    var goodsOfCategory: [GoodsOfCategory] = []
    
    init?(data: NSDictionary) {
        guard let id = data["id"] as? Int ?? Int(data["id"] as! String),
        let iconImage = data["iconImage"] as? String,
//        let sortOrder = data["sortOrder"] as? Int ?? Int(data["sortOrder"] as! String),
        let name = data["name"] as? String else {
            return nil
        }
        self.id = id
        self.iconImage = iconImage
        self.iconUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(iconImage)")!))?.trim()
        self.name = name
//        self.goodsOfCategory = CatalogData.instance.requestGoodsData(idOfSubCategory: self.id)
    }
    
}


class GoodsOfCategory {
    
    let name: String
    let englishName: String
    let sortOrder: Int
    let article: String
    let description: String
    let goodsImage: String
    let goodsUIImage: UIImage?
    let price: Double
    
    init?(data: NSDictionary) {
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
        self.description = description
        print("Special Price= \(price)")
        self.price = price
        self.goodsImage = mainImage
        self.goodsUIImage = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(mainImage)")!))?.trim()
    }
    
}


extension CatalogData {
    
    func requestCategoriesData() {
        var categories: [CategoriesForCatalog] = []
        let request = AF.request("https://blackstarshop.ru/index.php?route=api/v1/categories")
        AppSystemData.instance.VCMainCatalogDelegate!.hudAppear()
        request.responseJSON(completionHandler: { response in
            if let object = response.value, let jsonDict = object as? NSDictionary {
//                print("jsonDict= \(jsonDict)")
                    for (index, data) in jsonDict where data is NSDictionary{
                            print("index= \(index)")
                        if let category = CategoriesForCatalog(data: data as! NSDictionary) {
                            print("111")
                            if category.image != "" && category.subCategories != [] {
                                category.subCategories.removeAll{ value in return value.iconImage == ""}
                                category.id = index as? Int ?? Int(index as! String) ?? 0
                                categories.append(category)
//                                print("\(category.id)")
                            }
                        }
                    }
                CatalogData.instance.categoriesArray = categories
                CatalogData.instance.showCategories()
                AppSystemData.instance.VCMainCatalogDelegate!.mainCatalogCollectionUpdate()
                AppSystemData.instance.VCMainCatalogDelegate!.hudDisapper()
                print("categories= \(categories)")
                }
            })
    }
    
    
    func requestGoodsData() {
        let idOfCategory = AppSystemData.instance.activeCatalogCategory
        let idOfSubCategory = AppSystemData.instance.activeCatalogSubCategory
//        print("idOfSubCategory= \(idOfSubCategory)")
        let tempA: Int = CatalogData.instance.categoriesArray.firstIndex(where: { $0.sortOrder == idOfCategory })!
        let tempB: Int = CatalogData.instance.categoriesArray[tempA].subCategories.firstIndex(where: { $0.id == AppSystemData.instance.activeCatalogSubCategory })!
        print("111_idOfCategory= \(idOfCategory)")
        print("111_idOfSubCategory= \(idOfSubCategory)")
        print("111_activeCatalogCategory= \(AppSystemData.instance.activeCatalogCategory)")
        print("111_activeCatalogSubCategory= \(AppSystemData.instance.activeCatalogSubCategory)")
        print("222_subcategoryname = \(CatalogData.instance.categoriesArray[tempA].subCategories[tempB].name)")
        
        var goods: [GoodsOfCategory] = []
        let request = AF.request("https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(idOfSubCategory)")
        AppSystemData.instance.VCMainCatalogDelegate!.hudAppear()
        request.responseJSON(completionHandler: { response in
            if let object = response.value, let jsonDict = object as? NSDictionary {
                print("jsonDict= \(jsonDict)")
                    for (index, data) in jsonDict where data is NSDictionary{
                            print("index= \(index)")
                        if let product = GoodsOfCategory(data: data as! NSDictionary) {
                            print("777")
                            if product.goodsImage != "" {
                                goods.append(product)
                                print("\(product) is add to goods")
                            }
                        }
                    }
                print("goods1= \(goods)")
                print("jsonDict.count= \(jsonDict.count)")
                print("goods.count= \(goods.count)")
                CatalogData.instance.categoriesArray[tempA].subCategories[tempB].goodsOfCategory = goods
                AppSystemData.instance.VCMainCatalogDelegate!.mainCatalogCollectionUpdate()
                AppSystemData.instance.VCMainCatalogDelegate!.hudDisapper()
                }
            })
        print("goods2= \(goods)")
    }

}
