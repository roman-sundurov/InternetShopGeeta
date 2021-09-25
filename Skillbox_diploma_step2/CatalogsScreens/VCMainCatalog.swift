//
//  VCMainCatalog.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit
import Alamofire
import JGProgressHUD


class VCMainCatalog: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var slideProfileMenu: UIView!
    @IBOutlet var menuButtonView: UIView!
    @IBOutlet var menuButtonHorizonGesture: UIPanGestureRecognizer!
    @IBOutlet var catalogCollectionView: UICollectionView!
    

    //MARK: - делегаты и переменные
    
    var menuState: Bool = false
    var categories: [CategoriesForCatalog] = []
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    var itemsPerRow: CGFloat = 2
    
    //MARK: - объекты
    
    let hud = JGProgressHUD()
    
    
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
    
    func requestData() {
        var categories: [CategoriesForCatalog] = []
        let request = AF.request("https://blackstarshop.ru/index.php?route=api/v1/categories")
        hud.show(in: self.view)
        request.responseJSON(completionHandler: { response in
            if let object = response.value, let jsonDict = object as? NSDictionary {
                    for (index, data) in jsonDict where data is NSDictionary{
                            print("index= \(index)")
                        if let category = CategoriesForCatalog(data: data as! NSDictionary) {
                            categories.append(category)
                        }
                    }
                AllCategories.instance.categoriesArray = categories
                AllCategories.instance.showCategories()
                }
            })
        hud.dismiss(afterDelay: 3.0)
    }
    
    //MARK: - screen update
    
    func mainCatalogCollectionUpdate() {

        

    }

    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButtonView.layer.cornerRadius = 8
        menuButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        menuButtonView.layer.borderWidth = 0
        menuButtonView.layer.borderColor = UIColor.clear.cgColor
        menuButtonView.clipsToBounds = true
        
        hud.textLabel.text = "Loading"
        requestData()
        
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
    return 5//temporaryCategoryArray.count
  }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCollectionViewCell

        cell.bottomView.layer.cornerRadius = 30
        cell.bottomView.clipsToBounds = true
        cell.productImage.image = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/image/catalog/im2017/4.png")!))?.trim()
//        print("cell.productImage.frame.size.width= \(cell.productImage.frame.size.width)")
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / itemsPerRow
        cell.widthConstraint.constant = widthPerItem
        cell.heightConstraint.constant = widthPerItem * 1.3
        
        return cell
  }
}

extension VCMainCatalog: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      let paddingSpace = CGFloat(45.0) * (itemsPerRow + 1)
//      let availableWidth = view.frame.width - CGFloat(paddingSpace)
//      let widthPerItem = availableWidth / itemsPerRow
//        print("widthPerItem= \(widthPerItem)")
//        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left * 1.5
    }
}


extension UIImage {

    func trim() -> UIImage {
        let newRect = self.cropRect
        if let imageRef = self.cgImage!.cropping(to: newRect) {
            return UIImage(cgImage: imageRef)
        }
        return self
    }

    var cropRect: CGRect {
            guard let cgImage = self.cgImage,
                let context = createARGBBitmapContextFromImage(inImage: cgImage) else {
                    return CGRect.zero
            }

            let height = CGFloat(cgImage.height)
            let width = CGFloat(cgImage.width)
            let rect = CGRect(x: 0, y: 0, width: width, height: height)
            context.draw(cgImage, in: rect)

            guard let data = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return CGRect.zero
            }

            var lowX = width
            var lowY = height
            var highX: CGFloat = 0
            var highY: CGFloat = 0
            let heightInt = Int(height)
            let widthInt = Int(width)

            // Filter through data and look for non-transparent pixels.
            for y in 0 ..< heightInt {
                let y = CGFloat(y)

                for x in 0 ..< widthInt {
                    let x = CGFloat(x)
                    let pixelIndex = (width * y + x) * 4 /* 4 for A, R, G, B */

                    if data[Int(pixelIndex)] == 0 { continue } // crop transparent

                    if data[Int(pixelIndex+1)] > 0xE0 && data[Int(pixelIndex+2)] > 0xE0 && data[Int(pixelIndex+3)] > 0xE0 { continue } // crop white

                    lowX = min(x, lowX)
                    highX = max(x, highX)

                    lowY = min(y, lowY)
                    highY = max(y, highY)
                }
            }

            return CGRect(x: lowX, y: lowY, width: highX - lowX, height: highY - lowY)
        }

    func createARGBBitmapContextFromImage(inImage: CGImage) -> CGContext? {

        let width = inImage.width
        let height = inImage.height

        let bitmapBytesPerRow = width * 4
        let bitmapByteCount = bitmapBytesPerRow * height

        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmapData = malloc(bitmapByteCount)
        if bitmapData == nil {
            return nil
        }

        let context = CGContext (data: bitmapData,
                                 width: width,
                                 height: height,
                                 bitsPerComponent: 8,      // bits per component
            bytesPerRow: bitmapBytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

        return context
    }

}


