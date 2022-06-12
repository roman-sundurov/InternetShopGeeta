//
//  VCLogin.swift
//  Skillbox_diploma_step2
//
//  Created by Roman on 20.07.2021.
//

import UIKit
import SimpleCheckbox


class VCLogin: UIViewController {
  // MARK: - объявление аутлетов

  @IBOutlet var emailView: TextFieldView!
  @IBOutlet var rememberMeCheckbox: Checkbox!
  @IBOutlet var constraintSuperDownMenuBottom: NSLayoutConstraint!

  // MARK: - делегаты и переменные
  var keyboardHeight: CGFloat = 0 // хранит высоту клавиатуры
  // MARK: - объекты

  let alertGoingBack = UIAlertController(
    title: "Login не работает, пройдите на страницу регистрации",
    message: nil,
    preferredStyle: .alert
  )

  func createAlertNotRegistration() {
    alertGoingBack.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil ))
  }

  // MARK: - переходы
  @IBAction func buttonCloseLoginScreen(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func buttonSegueToVCMainCatalog(_ sender: Any) {
    self.present(alertGoingBack, animated: true, completion: nil)
  }

  @IBAction func buttonSegueToVCRegister(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCRegister", sender: nil)
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
        options: UIView.AnimationOptions()
      ) {
        if self.constraintSuperDownMenuBottom.constant > 0 {
          self.constraintSuperDownMenuBottom.constant = CGFloat.init(0)
        }
        self.view.layoutIfNeeded()
      }
    }
  }

  // MARK: - клики

  // MARK: - данные

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
    super.viewWillDisappear(true)
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: - viewDidLoad

  override func viewDidLoad() {
    super.viewDidLoad()

    rememberMeCheckbox.checkmarkStyle = .tick
    rememberMeCheckbox.borderLineWidth = 1
    rememberMeCheckbox.checkedBorderColor = UIColor.gray
    rememberMeCheckbox.uncheckedBorderColor = UIColor.gray
    rememberMeCheckbox.borderStyle = .square
    rememberMeCheckbox.checkmarkSize = 0.5
    rememberMeCheckbox.checkmarkColor = UIColor(named: "Purple")
    createAlertNotRegistration()
  }

  // MARK: - additional protocols

}
