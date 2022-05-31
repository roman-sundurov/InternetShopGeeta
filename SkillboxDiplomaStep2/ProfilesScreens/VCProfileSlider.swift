//
//  VCProfileSlider.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit


class VCProfileSlider: UIViewController {
  // MARK: - объявление аутлетов

  @IBOutlet var accountImage: UIImageView!
  @IBOutlet var lableName: UILabel!
  @IBOutlet var labelEmail: UILabel!

  // MARK: - делегаты и переменные
  // MARK: - объекты
  // MARK: - переходы


  // MARK: - клики
  @IBAction func gestureLogOut(_ sender: Any) {
    AppSystemData.instance.vcMainCatalogDelegate?.logOut()
  }

  @IBAction func gestureGoCartScreen(_ sender: Any) {
    AppSystemData.instance.vcMainCatalogDelegate!.slideSimpleClose()
    AppSystemData.instance.vcMainCatalogDelegate!.performSegue(withIdentifier: "segueToVCCart", sender: nil)
  }

  @IBAction func gestureGoFavoriteScreen(_ sender: Any) {
//        AppSystemData.instance.VCMainCatalogDelegate!.slideSimpleClose()
//        AppSystemData.instance.VCMainCatalogDelegate!.performSegue(withIdentifier: "segueToVCFavorite", sender: nil)
  }

  // MARK: - данные
  func updateScreenData() {
    lableName.text = Persistence.shared.getAllObjectPersonalData().first?.name
    labelEmail.text = Persistence.shared.getAllObjectPersonalData().first?.email
  }

  // MARK: - viewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()

    accountImage.layer.cornerRadius = 30
    accountImage.layer.borderWidth = 3
    accountImage.layer.borderColor = UIColor.white.cgColor
    accountImage.clipsToBounds = true
    accountImage.backgroundColor = .white

    updateScreenData()
  }

  // MARK: - additional protocols
}
