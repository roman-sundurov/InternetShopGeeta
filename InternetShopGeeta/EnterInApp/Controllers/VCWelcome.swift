//
//  ViewController.swift
//  InternetShopGeeta
//
//  Created by Roman on 14.06.2021.
//

import UIKit


class VCWelcome: UIViewController {
  // MARK: - клики
  @IBAction func buttonSegueToVCRecognition(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCRecognition", sender: nil)
  }

  @IBOutlet var buttonSegueToVCRecognition: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
