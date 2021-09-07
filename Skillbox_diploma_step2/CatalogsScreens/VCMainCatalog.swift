//
//  VCMainCatalog.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit

class VCMainCatalog: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var slideProfileMenu: UIView!
    @IBOutlet var menuButtonView: UIView!
    @IBOutlet var menuButtonHorizonGesture: UIPanGestureRecognizer!
    @IBOutlet var catalogCollectionView: UICollectionView!
    

    //MARK: - делегаты и переменные
    
    var menuState: Bool = false
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    var itemsPerRow: CGFloat = 2
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    //MARK: - клики, жесты
    
    @IBAction func handlerButtonTapGesture(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            print("buttonTapp")
            slideProfileMenuPushed(gesture: gesture, gestureView: menuButtonView, isTap: true)
        }
    }
    
    @IBAction func handlerMenuButtonHorizonGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else {
          return
        }
        if gestureView.frame.origin.x + translation.x >= UIScreen.main.bounds.width - gesture.view!.frame.size.width - 255 && gestureView.frame.origin.x + translation.x <= UIScreen.main.bounds.width - gesture.view!.frame.size.width {
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
    
    
    func slideProfileMenuPushed(gesture: UIGestureRecognizer, gestureView: UIView, isTap: Bool) {
        if slideProfileMenu.frame.origin.x >= UIScreen.main.bounds.width - 255 / 2 {
            if isTap == true {
                slideOpen()
            } else {
                slideClose()
            }
        }
        else {
            if isTap == true {
                slideClose()
            } else {
                slideOpen()
            }
        }
        
        func slideClose() {
            print("111")
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                gestureView.frame.origin.x = UIScreen.main.bounds.width - self.menuButtonView.frame.size.width
                self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width
            })
        }
        
        func slideOpen() {
            print("222")
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                gestureView.frame.origin.x = UIScreen.main.bounds.width - self.menuButtonView.frame.size.width - 255
                self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width - 255
            })
        }
        
    }
    
    
    //MARK: - данные
    
    var temporaryCategoryArray: [CatalogCategory] = []
    
    //Запись временных данных
    func temporaryData() {
        
        var temporaryCategory = CatalogCategory()
        temporaryCategory.name = "Аксессуары"
        temporaryCategory.sortOrder = 29
        temporaryCategory.image = "image/catalog/im2017/4.png"
        temporaryCategory.iconImage = "image/catalog/style/modile/acc_cat.png"
        temporaryCategory.iconImageActive = "image/catalog/style/modile/acc_cat_active_s.png"
        
        var temporaryCategory2 = CatalogCategory()
        temporaryCategory2.name = "Женская"
        temporaryCategory2.sortOrder = 11
        temporaryCategory2.image = "image/catalog/im2017/1.png"
        temporaryCategory2.iconImage = "image/catalog/style/modile/girl_cat.png"
        temporaryCategory2.iconImageActive = "image/catalog/style/modile/girl_cat_active_s.png"
        
        temporaryCategoryArray.append(temporaryCategory)
        temporaryCategoryArray.append(temporaryCategory2)
    }
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButtonView.layer.cornerRadius = 8
        menuButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        menuButtonView.layer.borderWidth = 0
        menuButtonView.layer.borderColor = UIColor.clear.cgColor
        menuButtonView.clipsToBounds = true

        temporaryData()
        print(temporaryCategoryArray)
        
    }

}


//MARK: - additional protocols

extension VCMainCatalog: UICollectionViewDataSource {
  // 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  // 2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4//temporaryCategoryArray.count
  }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCollectionViewCell

        cell.layer.cornerRadius = 30
        cell.bottomView.clipsToBounds = true
        cell.productImage.image = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/image/catalog/im2017/4.png")!))
        cell.productImage.contentMode = .center
        return cell
  }
}

extension VCMainCatalog: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - CGFloat(paddingSpace)
      let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
}
