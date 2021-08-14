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
    

    //MARK: - делегаты и переменные
    
    var menuState: Bool = false
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    //MARK: - клики, жесты
    
    @IBAction func handlerButtonTapGesture(_ gesture: UITapGestureRecognizer) {
//        if gesture.state == UIGestureRecognizer.State.ended {
//            print("Tap menu ended")
//            let pointOfTap = gesture.location(in: self.view)
//            if containerBottomOperationScreen1.frame.contains(pointOfTap) {
//                print("Tap inside Container")
//            }
//            else {
//                print("Tap outside Container")
//                actionsOperationsClosePopUpScreen1()
//            }
//        }
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
            print("gestureView.frame.origin.x= \(gestureView.frame.origin.x)")
            print("UIScreen.main.bounds.width - 255/2 = \(UIScreen.main.bounds.width - (255/2))")
            print("slideProfileMenu.frame.origin.x= \(slideProfileMenu.frame.origin.x)")
            print("translation.x= \(translation.x)")
            
            if slideProfileMenu.frame.origin.x >= UIScreen.main.bounds.width - 255 / 2 {
                print("111")
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                    gestureView.frame.origin.x = UIScreen.main.bounds.width - gesture.view!.frame.size.width
                    self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width
                })
            }
            else {
                print("222")
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                    gestureView.frame.origin.x = UIScreen.main.bounds.width - gesture.view!.frame.size.width - 255
                    self.slideProfileMenu.frame.origin.x = UIScreen.main.bounds.width - 255
                })
            }
        }
        
        gesture.setTranslation(.zero, in: view)
        
        guard gesture.state == .ended else {
            return
        }
    }
    
    
    //MARK: - данные
    
    //MARK: - viewDidLoad
    
    //MARK: - additional protocols
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButtonView.layer.cornerRadius = 8
        menuButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        menuButtonView.layer.borderWidth = 0
        menuButtonView.layer.borderColor = UIColor.clear.cgColor
        menuButtonView.clipsToBounds = true

        
        
    }

}
