//
//  PersistenceViewModel.swift
//  InternetShopGeeta
//
//  Created by Roman on 11.06.2022.
//

import Foundation
import RealmSwift
import Alamofire

// MARK: - extension Persistence
extension Persistence {
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


// MARK: - extension CatalogData
extension CatalogData {
  func getCategoriesArray() -> [Categories] {
    return categoriesArray
  }

  func setCategoriesArray(newArray: [Categories]) {
    categoriesArray = newArray
  }

  func getSubcategoriesData() -> [NSDictionary] {
    let categoriesArray = CatalogData.instance.getCategoriesArray()
    let tempA: Int = categoriesArray.firstIndex {
      $0.sortOrder == AppSystemData.instance.activeCatalogCategory
    }!
    return categoriesArray[tempA].subCategoriesData
  }

  func setSubcategoriesArray(newArray: [SubCategories]) {
    let categoriesArray = CatalogData.instance.getCategoriesArray()
    let tempA: Int = categoriesArray.firstIndex {
      $0.sortOrder == AppSystemData.instance.activeCatalogCategory
    }!
    categoriesArray[tempA].subCategories = newArray
  }

  func requestCategoriesData() async {
    await AppSystemData.instance.vcMainCatalogDelegate!.hudAppear()
    guard AppSystemData.instance.activeCatalogMode != "product" else {
      return
    }
    let request = AF.request(CatalogData.requestCategoriesPath)
    request.responseJSON { response in
      if let object = response.value, let jsonDict = object as? NSDictionary {
        Task.init(priority: .userInitiated) {
          var categories: [Categories] = []
          for ( _, data) in jsonDict where data is NSDictionary {
            // print("TAKT_1")
            if let category = Categories(data: data as! NSDictionary) {
              categories.append(category)
            }
            CatalogData.instance.setCategoriesArray(newArray: categories)
            Task.init(priority: .high) {
              await AppSystemData.instance.vcMainCatalogDelegate?.catalogCollectionViewUpdate()
            }
          }
          Task.init(priority: .high) {
            await AppSystemData.instance.vcMainCatalogDelegate?.hudDisapper()
          }
        }
      }
    }
  }

  func requestSubcategoriesData() async {
    print("requestSubcategoriesData")
    print("activeCatalogMode == \(AppSystemData.instance.activeCatalogMode)")
    await AppSystemData.instance.vcMainCatalogDelegate?.hudAppear()
    guard AppSystemData.instance.activeCatalogMode != "subcategories" else {
      print("Strange activeCatalogMode == \(AppSystemData.instance.activeCatalogMode)")
      return
    }
    Task.init(priority: .userInitiated) {
      var subcategories: [SubCategories] = []
      let object = CatalogData.instance.getSubcategoriesData()
      for data in object {
        print("TAKT_2")
        if let subCategories2 = SubCategories(data: data) {
          subcategories.append(subCategories2)
          print("subCategories2.name= \(subCategories2.name)")
        }
        CatalogData.instance.setSubcategoriesArray(newArray: subcategories)
        Task.init(priority: .high) {
          await AppSystemData.instance.vcMainCatalogDelegate?.catalogCollectionViewUpdate()
        }
      }
      Task.init(priority: .high) {
        await AppSystemData.instance.vcMainCatalogDelegate?.hudDisapper()
      }
    }
  }

  func requestGoodsData() async {
    await AppSystemData.instance.vcMainCatalogDelegate?.hudAppear()
    let idOfCategory = AppSystemData.instance.activeCatalogCategory
    let idOfSubCategory = AppSystemData.instance.activeCatalogSubCategory
    let categoriesArray = CatalogData.instance.getCategoriesArray()
    let tempA: Int = categoriesArray.firstIndex {
      $0.sortOrder == idOfCategory
    }!
    let tempB: Int = categoriesArray[tempA].subCategories.firstIndex {
      $0.id == AppSystemData.instance.activeCatalogSubCategory
    }!

    let request = AF.request("https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(idOfSubCategory)")
    request.responseJSON { response in
      if let object = response.value, let jsonDict = object as? NSDictionary {
        Task.init(priority: .userInitiated) {
          var goods: [Products] = []
          for (_, data) in jsonDict where data is NSDictionary {
            // print("TAKT_3")
            if let product = Products(data: data as! NSDictionary) {
              goods.append(product)
            }
            categoriesArray[tempA].subCategories[tempB].goodsOfCategory = goods
            Task.init(priority: .high) {
              await AppSystemData.instance.vcMainCatalogDelegate?.catalogCollectionViewUpdate()
            }
          }
          print("goods2= \(goods)")
        }
        Task.init(priority: .high) {
          await AppSystemData.instance.vcMainCatalogDelegate?.hudDisapper()
        }
      }
    }
  }

  func isCategoryContain(category: String, place: [CartCategoriesAndProductsDiffable]) -> Int {
    var result: Int = -1
    var checker: Int = 0

    for data in place {
      if data.category == category {
        result = checker
        break
      }
      checker += 1
    }
    return result
  }

  func updateCatalogsAndCartGoodsDiffableArray() {
    print("updateCatalogsAndCartGoodsDiffable")
    cartCategoriesAndProductsDiffableArray = []
    for persistenceCartGood in Persistence.shared.getAllObjectOfCart() {
      if cartCategoriesAndProductsDiffableArray.isEmpty == false {
        let id = isCategoryContain(
          category: persistenceCartGood.category,
          place: cartCategoriesAndProductsDiffableArray)
        if id >= 0 {
          print("updateCatalogsAndCartGoodsDiffableArray id != 0, \(persistenceCartGood.category)")
          cartCategoriesAndProductsDiffableArray[id].cartGoodsDiffable.append(Cart.init(
            name: persistenceCartGood.name,
            catalog: persistenceCartGood.category,
            englishName: persistenceCartGood.englishName,
            sortOrder: persistenceCartGood.sortOrder,
            article: persistenceCartGood.article,
            descriptionGoods: persistenceCartGood.description,
            goodsImage: persistenceCartGood.goodsImage,
            goodsUIImageData: persistenceCartGood.goodsUIImageData,
            price: persistenceCartGood.price,
            isFavorite: persistenceCartGood.isFavorite,
            size: persistenceCartGood.size!
          ))
        } else {
          print("updateCatalogsAndCartGoodsDiffableArray id == 0, \(persistenceCartGood.category)")
          cartCategoriesAndProductsDiffableArray.append(CartCategoriesAndProductsDiffable.init(
            catalog: persistenceCartGood.category,
            cartGoods: [
              Cart.init(
                name: persistenceCartGood.name,
                catalog: persistenceCartGood.category,
                englishName: persistenceCartGood.englishName,
                sortOrder: persistenceCartGood.sortOrder,
                article: persistenceCartGood.article,
                descriptionGoods: persistenceCartGood.description,
                goodsImage: persistenceCartGood.goodsImage,
                goodsUIImageData: persistenceCartGood.goodsUIImageData,
                price: persistenceCartGood.price,
                isFavorite: persistenceCartGood.isFavorite,
                size: persistenceCartGood.size!
              )
            ]
          ))
        }
      } else {
        print("updateCatalogsAndCartGoodsDiffableArray emptyArray, \(persistenceCartGood.category)")
        cartCategoriesAndProductsDiffableArray.append(CartCategoriesAndProductsDiffable.init(
          catalog: persistenceCartGood.category,
          cartGoods: [
            Cart.init(
              name: persistenceCartGood.name,
              catalog: persistenceCartGood.category,
              englishName: persistenceCartGood.englishName,
              sortOrder: persistenceCartGood.sortOrder,
              article: persistenceCartGood.article,
              descriptionGoods: persistenceCartGood.description,
              goodsImage: persistenceCartGood.goodsImage,
              goodsUIImageData: persistenceCartGood.goodsUIImageData,
              price: persistenceCartGood.price,
              isFavorite: persistenceCartGood.isFavorite,
              size: persistenceCartGood.size!
            )
          ]
        ))
      }
    }
  }

  func getAllCatalogsAndCartGoodsDiffable() -> [CartCategoriesAndProductsDiffable] {
    print("getAllCatalogsAndCartGoodsDiffable1= \(cartCategoriesAndProductsDiffableArray)")
    updateCatalogsAndCartGoodsDiffableArray()
    print("getAllCatalogsAndCartGoodsDiffable2= \(cartCategoriesAndProductsDiffableArray)")
    return cartCategoriesAndProductsDiffableArray
  }
}
