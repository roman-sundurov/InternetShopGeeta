//
//  VCMainCatalog.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit
import JGProgressHUD

class VCMainCatalog: UIViewController {
  // MARK: - объявление аутлетов
  @IBOutlet var slideProfileMenu: UIView!
  @IBOutlet var menuButtonView: UIView!
  @IBOutlet var menuButtonHorizonGesture: UIPanGestureRecognizer!
  @IBOutlet var catalogCollectionView: UICollectionView!
  @IBOutlet var constraintSecondMenuStrip2: NSLayoutConstraint!
  @IBOutlet var buttonSecondMenuCategories: UIView!
  @IBOutlet var buttonSecondMenuMens: UIView!
  @IBOutlet var buttonSecondMenuWomens: UIView!
  @IBOutlet var buttonSecondMenuSale: UIView!
  @IBOutlet var labelCategories: UILabel!
  @IBOutlet var labelMens: UILabel!
  @IBOutlet var labelWomens: UILabel!
  @IBOutlet var labelSales: UILabel!
  @IBOutlet var secondMenuStrip2: UIView!


  // MARK: - делегаты и переменные
  enum SectionCategories {
    case main
  }

  internal lazy var dataSourceCategoriesMode = makeDataSourceCategoriesMode()
  internal lazy var dataSourceSubcategoriesMode = makeDataSourceSubcategoriesMode()
  internal lazy var dataSourceProductMode = makeDataSourceProductMode()

  typealias DataSourceAliastCatalogMode = UICollectionViewDiffableDataSource<SectionCategories, Categories>
  typealias SnapshotAliasCatalogMode = NSDiffableDataSourceSnapshot<SectionCategories, Categories>

  typealias DataSourceAliastSubcategoriesMode = UICollectionViewDiffableDataSource<SectionCategories, SubCategories>
  typealias SnapshotAliasSubcategoriesMode = NSDiffableDataSourceSnapshot<SectionCategories, SubCategories>

  typealias DataSourceAliasProductMode = UICollectionViewDiffableDataSource<SectionCategories, Products>
  typealias SnapshotAliasProductMode = NSDiffableDataSourceSnapshot<SectionCategories, Products>

  var menuState = false
  let sectionInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
  var itemsPerRow: CGFloat = 2


  // MARK: - объекты
  let hud = JGProgressHUD()
  @IBOutlet var mainView: UIView!


  // MARK: - клики, жесты
  @IBAction func cartActionButton(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCCart", sender: nil)
  }


  @IBAction func handlerButtonTapGesture(_ gesture: UITapGestureRecognizer) {
    if gesture.state == .ended {
      print("buttonTapp")
      slideProfileMenuPushed(gesture: gesture, gestureView: menuButtonView, isTap: true)
    }
  }


  // Обработка горизонтального перемещения бокового меню
  @IBAction func handlerMenuButtonHorizonGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: view)
    guard let gestureView = gesture.view else {
      return
    }
    let originX = gestureView.frame.origin.x
    let screenW = UIScreen.main.bounds.width
      let xxxWidth = gesture.view!.frame.size.width
    if originX + translation.x >= screenW - xxxWidth - 255 && originX + translation.x <= screenW - xxxWidth {
      gestureView.center = CGPoint(
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y
      )
      slideProfileMenu.center = CGPoint(
        x: slideProfileMenu.center.x + translation.x,
        y: slideProfileMenu.center.y
      )
    }

    if gesture.state == .ended {
      slideProfileMenuPushed(gesture: gesture, gestureView: gestureView, isTap: false)
    }

    gesture.setTranslation(.zero, in: view)

    guard gesture.state == .ended else {
      return
    }
  }

  @IBAction func catalogBackButtonAction(_ sender: Any) {
    print("332")
    if AppSystemData.instance.activeCatalogMode == "subcategories" {
      print("333")
      dataSourceSubcategoriesMode = makeDataSourceSubcategoriesMode()
      dataSourceCategoriesMode = makeDataSourceCategoriesMode()
      AppSystemData.instance.activeCatalogMode = "categories"
      buttonCategoriesGesture(nil)
      print("334")
    } else if AppSystemData.instance.activeCatalogMode == "product" {
      dataSourceSubcategoriesMode = makeDataSourceSubcategoriesMode()
      dataSourceProductMode = makeDataSourceProductMode()
      print("334")
      AppSystemData.instance.activeCatalogMode = "subcategories"
      switch AppSystemData.instance.activeCatalogCategory {
      case 0:
        buttonMensGesture(nil)
      case 11:
        buttonWomensGesture(nil)
      case 99:
        buttonSaleGesture(nil)
      default:
        hideSecondMenu()
      }
    }
  }

  // Push "Categories" button in upper menu
  @IBAction func buttonCategoriesGesture(_ sender: Any?) {
    borderLineForSecondMenu(button: 1)
    changeModeIntoSecondMenu(activeMode: "categories", categoriesID: 0)
  }

  // Push "Mens" button in upper menu
  @IBAction func buttonMensGesture(_ sender: Any?) {
    borderLineForSecondMenu(button: 2)
    changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 0)
  }

  // Push "Womens" button in upper menu
  @IBAction func buttonWomensGesture(_ sender: Any?) {
    borderLineForSecondMenu(button: 3)
    changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 11)
  }


  // Push "Sale" button in upper menu
  @IBAction func buttonSaleGesture(_ sender: Any?) {
    borderLineForSecondMenu(button: 4)
    changeModeIntoSecondMenu(activeMode: "subcategories", categoriesID: 99)
  }


  // MARK: - viewWillAppear
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    // AppSystemData.instance.activeCatalogMode = "categories"
    CatalogData.instance.requestCategoriesData()
    if AppSystemData.instance.activeCatalogMode == "product" {
      CatalogData.instance.requestGoodsData()
    }
  }


  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad")
    // AppSystemData.instance.activeCatalogMode = "categories"
    print("AppSystemData.instance.VCMainCatalogDelegate_222= \(AppSystemData.instance.vcMainCatalogDelegate)")
    AppSystemData.instance.vcMainCatalogDelegate = self
    applySnapshot(animatingDifferences: false)
    menuButtonView.layer.cornerRadius = 8
    menuButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    menuButtonView.layer.borderWidth = 0
    menuButtonView.layer.borderColor = UIColor.clear.cgColor
    menuButtonView.clipsToBounds = true
    hud.textLabel.text = "Loading"
  }
}
