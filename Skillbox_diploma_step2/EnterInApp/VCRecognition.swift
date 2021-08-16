//
//  VCRecognition.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 17.07.2021.
//

import UIKit

class VCRecognition: UIViewController {
    

    //MARK: - объявление аутлетов
    @IBOutlet var buttonSegueToVCLogin: UIButton!
    
    //MARK: - делегаты и переменные
    
    //MARK: - объекты
    
    //MARK: - переходы
    
    @IBAction func buttonSegueToVCRecognition(_ sender: Any) {
        performSegue(withIdentifier: "segueToVCLogin", sender: nil)
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
