//
//  VCLaunchScreen.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 09.11.2021.
//

import UIKit

class VCLaunchScreen: UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty == false {
            performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
            print("segueToVCMainCatalog Yes= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
            print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
        } else {
            performSegue(withIdentifier: "segueToVCWelcome", sender: nil)
            print("segueToVCMainCatalog No= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
            print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
