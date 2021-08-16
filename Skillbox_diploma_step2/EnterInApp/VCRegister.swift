//
//  VCRegister.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit

class VCRegister: UIViewController {

    
    //MARK: - объявление аутлетов
    
    @IBOutlet var emailView: TextFieldView!
    
    //MARK: - делегаты и переменные
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    @IBAction func buttonCloseRegisterScreen(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonSegueToVCMainCatalog(_ sender: Any) {
        performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
    }
    
    
    //MARK: - клики
    
    //MARK: - данные
    
    //MARK: - viewDidLoad
    
    //MARK: - additional protocols
    
    
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
