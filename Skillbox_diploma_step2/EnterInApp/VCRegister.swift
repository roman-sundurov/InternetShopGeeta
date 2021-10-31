//
//  VCRegister.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit

class VCRegister: UIViewController {

    
    //MARK: - объявление аутлетов
    
    @IBOutlet var textFieldFullName: UITextField!
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    
    @IBOutlet var imageFullNameError: UIImageView!
    @IBOutlet var imageEmailError: UIImageView!
    @IBOutlet var imagePasswordError: UIImageView!
    
    //MARK: - делегаты и переменные
    
    var checkForRegister: Bool = false

    
    //MARK: - переходы
    
    @IBAction func buttonCloseRegisterScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    //MARK: - клики
    
    @IBAction func buttonSegueToVCMainCatalog(_ sender: Any) {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let passwordRegEx = ".+"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        if textFieldFullName.text != "" {
            print("fullname Ok")
            imageFullNameError.isHidden = true
        } else {
            print("fullname error")
            imageFullNameError.isHidden = false
        }
        
        if emailPred.evaluate(with: textFieldEmail.text) {
            print("email Ok")
            imageEmailError.isHidden = true
        } else {
            print("email error")
            imageEmailError.isHidden = false
        }
        
        if passwordPred.evaluate(with: textFieldPassword.text) {
            print("password Ok")
            imagePasswordError.isHidden = true
        } else {
            print("password error")
            imagePasswordError.isHidden = false
        }

        if imageFullNameError.isHidden, imageEmailError.isHidden, imagePasswordError.isHidden == true {
            print("Registration approved")
            Persistence.shared.addNewUser(fullName: textFieldFullName.text!, email: textFieldEmail.text!, password: textFieldPassword.text!)
            AppActualData.instance.setActualUser(userEmail: textFieldEmail.text!)
            performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
        }
    }
    
    
    //MARK: - данные
    
    
    //MARK: - viewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
