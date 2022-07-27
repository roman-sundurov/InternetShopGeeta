//
//  InternetShopGeetaUITests.swift
//  InternetShopGeetaUITests
//
//  Created by Roman on 14.06.2021.
//

import XCTest

var app: XCUIApplication!

class InternetShopGeetaUITests: XCTestCase {

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments += ["-reset-onboarding"]
    app.launch()
  }

  override func tearDownWithError() throws {
    app = nil
  }

  func testRegistration() throws {
    app.buttons["Get Started Button"].tap()
    app.buttons["RegisterButton"].tap()
    app.textFields["Your Name"].tap()
    app.textFields["Email address"].tap()
    app.secureTextFields["Password"].tap()
    app.buttons["RegisterButtonBig"].tap()
  }

  func testBuyTheProduct() throws {

  }

  func testLaunchPerformance() throws {
      if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
          // This measures how long it takes to launch your application.
          measure(metrics: [XCTApplicationLaunchMetric()]) {
              XCUIApplication().launch()
          }
      }
  }
}
