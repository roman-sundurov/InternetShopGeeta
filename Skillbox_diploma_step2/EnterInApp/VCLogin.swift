//
//  VCLogin.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 20.07.2021.
//

import UIKit
import SimpleCheckbox


class VCLogin: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var emailView: TextFieldView!
    @IBOutlet var rememberMeCheckbox: Checkbox!
    
    
    //MARK: - делегаты и переменные
    
    var keyboardHeight: CGFloat = 0 //хранит высоту клавиатуры
    
    
    //MARK: - объекты
    
    let alertGoingBack = UIAlertController(title: "Login не работает, пройдите на страницу регистрации", message: nil, preferredStyle: .alert)
    
    func createAlertNotRegistration() {
        alertGoingBack.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil ))
        
//        let labelAlertGoingBack = UILabel.init(frame: CGRect(x: 0, y: 0, width: 180, height: 50))
//        labelAlertGoingBack.numberOfLines = 2
//        labelAlertGoingBack.text = "Login не работает, пройдите на страницу регистрации"
//        labelAlertGoingBack.font = UIFont.systemFont(ofSize: CGFloat(14))
//        alertGoingBack.view.addSubview(labelAlertGoingBack)
//        labelAlertGoingBack.translatesAutoresizingMaskIntoConstraints = false
//
//        alertGoingBack.view.translatesAutoresizingMaskIntoConstraints = false
//
//        alertGoingBack.view.addConstraint(NSLayoutConstraint(item: labelAlertGoingBack, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250))
//        alertGoingBack.view.addConstraint(NSLayoutConstraint(item: labelAlertGoingBack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50))
//
//        alertGoingBack.view.addConstraint(NSLayoutConstraint(item: labelAlertGoingBack, attribute: .centerX, relatedBy: .equal, toItem: alertGoingBack.view, attribute: .centerX, multiplier: 1, constant: 0))
//        alertGoingBack.view.addConstraint(NSLayoutConstraint(item: labelAlertGoingBack, attribute: .top, relatedBy: .equal, toItem: alertGoingBack.view, attribute: .top, multiplier: 1, constant: 80))
//        alertGoingBack.view.addConstraint(NSLayoutConstraint(item: labelAlertGoingBack, attribute: .bottom, relatedBy: .equal, toItem: alertGoingBack.view, attribute: .bottom, multiplier: 1, constant: 40))
//
//        alertGoingBack.view.addConstraint(NSLayoutConstraint(item: alertGoingBack.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: labelAlertGoingBack.frame.height + 140))
//
//        print(alertGoingBack.view.frame.width)
//        print(labelAlertGoingBack.frame.width)
    }
    
    //MARK: - переходы
    
    @IBAction func buttonCloseLoginScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
                                           
    
    @IBAction func buttonSegueToVCMainCatalog(_ sender: Any) {
//        performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
        self.present(alertGoingBack, animated: true, completion: nil)
        
    }
    
    
    @IBAction func buttonSegueToVCRegister(_ sender: Any) {
        performSegue(withIdentifier: "segueToVCRegister", sender: nil)
    }
    
    
    //MARK: - анимация
    
//    @objc func keyboardWillAppear(_ notification: Notification) {
//        print("keyboardWillAppear")
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            keyboardHeight = keyboardRectangle.height
//        }
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
//            if self.constraintContainerBottomPoint.constant == 50{
//                self.constraintContainerBottomPoint.constant = self.keyboardHeight + CGFloat.init(20)
//            }
//            self.view.layoutIfNeeded()
//        }, completion: {isCompleted in })
//    }
//
//
//    @objc func keyboardWillDisappear(_ notification: Notification) {
//        if keyboardHeight != 0{
//            print("keyboardWillDisappear")
//            keyboardHeight = 0
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
//                if self.constraintContainerBottomPoint.constant > 50 {
//                    self.constraintContainerBottomPoint.constant = CGFloat.init(50)
//                }
//                self.view.layoutIfNeeded()
//            }, completion: {isCompleted in })
//        }
//    }
    
    
    //MARK: - клики
    
    //MARK: - данные
    
    //MARK: - viewDidLoad
    
    //MARK: - additional protocols

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rememberMeCheckbox.checkmarkStyle = .tick
        rememberMeCheckbox.borderLineWidth = 1
        rememberMeCheckbox.checkedBorderColor = UIColor.gray
        rememberMeCheckbox.uncheckedBorderColor = UIColor.gray
        rememberMeCheckbox.borderStyle = .square
        rememberMeCheckbox.checkmarkSize = 0.5
        rememberMeCheckbox.checkmarkColor = UIColor(named: "Purple")
        
        createAlertNotRegistration()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
