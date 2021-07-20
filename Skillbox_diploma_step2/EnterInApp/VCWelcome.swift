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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

