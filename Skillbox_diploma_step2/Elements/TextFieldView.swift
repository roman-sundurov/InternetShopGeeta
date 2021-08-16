//
//  TextFieldView.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 21.07.2021.
//

import UIKit

@IBDesignable class TextFieldView: UIView {
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 8
        layer.borderColor = UIColor(named: "Purple")?.cgColor//CGColor.init(red: 0.39, green: 0.26, blue: 0.91, alpha: 1)
        layer.borderWidth = 1

    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.layer.cornerRadius = 8
//        self.layer.borderColor = UIColor.init(named: "Purple")?.cgColor//CGColor.init(red: 0.39, green: 0.26, blue: 0.91, alpha: 1)
//    //        emailTextField.layer.borderColor = UIColor.red.cgColor
//        self.layer.borderWidth = 1
//
//    }
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
