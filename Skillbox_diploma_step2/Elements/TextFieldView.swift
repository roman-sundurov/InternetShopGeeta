//
//  TextFieldView.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 21.07.2021.
//

import UIKit

@IBDesignable
class TextFieldView: UIView {
  override func draw(_ rect: CGRect) {
    layer.cornerRadius = 8
    layer.borderColor = UIColor(named: "Purple")?.cgColor
    layer.borderWidth = 1
  }
}
