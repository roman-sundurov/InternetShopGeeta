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
    if Persistence.shared.getAllObjectPersonalData().first?.email.isEmpty == false && AppSystemData.instance.testWithoutUserMode == false {
      performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
    } else {
      performSegue(withIdentifier: "segueToVCWelcome", sender: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
