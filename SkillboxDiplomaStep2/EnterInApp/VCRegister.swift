//
//  VCRegister.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 23.07.2021.
//

import UIKit

class VCRegister: UIViewController {
  // MARK: - объявление аутлетов
  @IBOutlet var textFieldFullName: UITextField!
  @IBOutlet var textFieldEmail: UITextField!
  @IBOutlet var textFieldPassword: UITextField!
  @IBOutlet var imageFullNameError: UIImageView!
  @IBOutlet var imageEmailError: UIImageView!
  @IBOutlet var imagePasswordError: UIImageView!

  @IBOutlet var constraintSuperDownMenuBottom: NSLayoutConstraint!

  // MARK: - делегаты и переменные
  var checkForRegister = false
  var keyboardHeight: CGFloat = 0 //хранит высоту клавиатуры


  // MARK: - переходы
  @IBAction func buttonCloseRegisterScreen(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  // MARK: - анимация
  @objc func keyboardWillAppear(_ notification: Notification) {
    print("keyboardWillAppear")
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      keyboardHeight = keyboardRectangle.height
    }
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        if self.constraintSuperDownMenuBottom.constant == 0 {
          self.constraintSuperDownMenuBottom.constant = self.keyboardHeight - CGFloat.init(30)
        }
        self.view.layoutIfNeeded()
      },
      completion: { _ in })
  }


  @objc func keyboardWillDisappear(_ notification: Notification) {
    if keyboardHeight != 0 {
      print("keyboardWillDisappear")
      keyboardHeight = 0
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 0.8,
        initialSpringVelocity: 0,
        options: UIView.AnimationOptions(),
        animations: {
          if self.constraintSuperDownMenuBottom.constant > 0 {
            self.constraintSuperDownMenuBottom.constant = CGFloat.init(0)
          }
          self.view.layoutIfNeeded()
        },
        completion: { _ in })
    }
  }

  // MARK: - клики
  @IBAction func buttonSegueToVCMainCatalog(_ sender: Any) {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    let passwordRegEx = ".+"
    let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    if textFieldFullName.text?.isEmpty == false {
      print("fullname Ok")
      imageFullNameError.isHidden = true
    } else {
      print("fullname error")
      imageFullNameError.isHidden = false
    }
    if emailPred.evaluate(with: textFieldEmail.text) {
      print("email Ok")
      imageEmailError.isHidden = true
    } else {
      print("email error")
      imageEmailError.isHidden = false
    }
    if passwordPred.evaluate(with: textFieldPassword.text) {
      print("password Ok")
      imagePasswordError.isHidden = true
    } else {
      print("password error")
      imagePasswordError.isHidden = false
    }
    if imageFullNameError.isHidden, imageEmailError.isHidden, imagePasswordError.isHidden == true {
      print("Registration approved")
      print("666")
      Persistence.shared.activateNewUser(
        fullName: textFieldFullName.text!,
        email: textFieldEmail.text!,
        password: textFieldPassword.text!
      )
      print("777")
      performSegue(withIdentifier: "segueToVCMainCatalog", sender: nil)
    }
  }

  // MARK: - viewWillAppear
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillDisappear),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillAppear),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
  }


  // MARK: - viewWillDisappear
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Persistence.shared.printAllObject()_1= \(Persistence.shared.getAllObjectPersonalData())")
  }
}
