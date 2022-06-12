//
//  CatalogCollectionViewCell.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 06.09.2021.
//

import UIKit

class CatalogCategriesCollectionViewCell: UICollectionViewCell {
  @IBOutlet var categoryImage: UIImageView!
  @IBOutlet var upperView: UIView!
  @IBOutlet var widthConstraint: NSLayoutConstraint!
  @IBOutlet var heightConstraint: NSLayoutConstraint!
  @IBOutlet var nameCategory: UILabel!

  var specialTag: Int = 0
  var actionFromStartCellClosere: ( () -> Void )?

  @objc func gestureAction(tag: Int) {
    actionFromStartCellClosere!()
  }

  func startCell(tag: Int, action: @escaping () -> Void ) {
    specialTag = tag
    actionFromStartCellClosere = action
    let gesture = UITapGestureRecognizer(target: self, action: #selector(gestureAction(tag:) ))
    self.addGestureRecognizer(gesture)
  }
}
