//
//  ViewController.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 14.06.2021.
//

import UIKit


class VCWelcome: UIViewController {

    
    //MARK: - клики
    
    
    @IBAction func buttonSegueToVCRecognition(_ sender: Any) {
        performSegue(withIdentifier: "segueToVCRecognition", sender: nil)
    }
    
    
    @IBOutlet var buttonSegueToVCRecognition: UIButton!
    
//    override func viewWillLayoutSubviews() {
//        if Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty == false {
//            performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
//            print("segueToVCMainCatalog Yes= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
//            print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
//        } else {
//            print("segueToVCMainCatalog No= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
//            print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
//        }
//    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        if Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty == false {
//            performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
//            print("segueToVCMainCatalog Yes= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
//            print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
//        } else {
//            print("segueToVCMainCatalog No= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
//            print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
//        }
//
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        if Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty == false {
//            performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
//            print("segueToVCMainCatalog Yes= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
//            print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
//        } else {
//            print("segueToVCMainCatalog No= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
//            print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
//        }
//
    }


}

