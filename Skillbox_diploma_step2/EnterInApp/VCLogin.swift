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
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    @IBAction func buttonCloseLoginScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonSegueToVCMainCatalog(_ sender: Any) {
        performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
    }
    
    @IBAction func buttonSegueToVCRegister(_ sender: Any) {
        performSegue(withIdentifier: "segueToVCRegister", sender: nil)
    }
    
    
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
        
        
//        emailView.layer.cornerRadius = 8
//        emailView.layer.borderColor = UIColor.init(named: "Purple")?.cgColor//CGColor.init(red: 0.39, green: 0.26, blue: 0.91, alpha: 1)
////        emailTextField.layer.borderColor = UIColor.red.cgColor
//        emailView.layer.borderWidth = 1
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
