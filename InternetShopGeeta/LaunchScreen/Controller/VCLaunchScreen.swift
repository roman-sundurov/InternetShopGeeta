//
//  VCLaunchScreen.swift
//  InternetShopGeeta
//
//  Created by Roman on 09.11.2021.
//

import UIKit

class VCLaunchScreen: UIViewController {
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(false)
    var testWithoutModeLocal = AppSystemData.instance.testWithoutMode
    if Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty == false && AppSystemData.instance.testWithoutMode == false {
      performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
      // print("segueToVCMainCatalog Yes= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
      // print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
    } else {
      performSegue(withIdentifier: "segueToVCWelcome", sender: nil)
      // print("segueToVCMainCatalog No= \(Persistence.shared.getAllObjectPersonalData().first?.email)")
      // print("email.isEmpty= \(Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty)")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
