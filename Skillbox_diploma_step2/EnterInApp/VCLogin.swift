//
//  VCLogin.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 20.07.2021.
//

import UIKit

class VCLogin: UIViewController {
    
    
    //MARK: - объявление аутлетов
    
    @IBOutlet var emailTextField: UITextField!
    
    
    //MARK: - делегаты и переменные
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    //MARK: - клики
    
    //MARK: - данные
    
    //MARK: - viewDidLoad
    
    //MARK: - additional protocols

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = CGColor.init(red: 99, green: 66, blue: 232, alpha: 1)
        
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
