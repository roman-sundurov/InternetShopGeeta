//
//  InternetShopGeetaTests.swift
//  InternetShopGeetaTests
//
//  Created by Roman on 14.06.2021.
//

import XCTest
@testable import InternetShopGeeta

class InternetShopGeetaTests: XCTestCase {
  var category: Categories!
  var sut: CatalogData!
  let networkMonitor = NetworkMonitor.shared

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = CatalogData()
  }

  override func tearDownWithError() throws {
    category = nil
    sut = nil
    try super.tearDownWithError()
  }

  func testCategories() throws {
    // 1. given
    let bundle = Bundle(for: type(of: self))
    var json: Any?

    // 2. when
    guard let fileUrl = bundle.url(forResource: "testData", withExtension: "json") else {
      XCTFail("Missing file: testData.json")
      return
    }

    // 3. then
    do {
      let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
      json = try? JSONSerialization.jsonObject(with: data)
    } catch {
      XCTFail("Json error")
    }
    if let object = json, let jsonDict = object as? NSDictionary {
      for ( _, data2) in jsonDict {
        category = Categories(data: data2 as! NSDictionary)
        print("333categories.name= \(category!.name)")
      }
    } else {
      XCTFail("Error in jsonDict")
    }
    XCTAssertEqual(category.name, "Аксессуары", "Name is wrong")
  }

  func testPerformanceCategorization() throws {
    self.measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTStorageMetric(), XCTMemoryMetric()]) {
      do {
        try testCategories()
      } catch {
        XCTFail("Error in testPerformanceCategorization()")
      }
    }
  }

  func testPerformanceApiRequest() throws {
    try XCTSkipUnless(
      networkMonitor.isReachable,
      "Network connectivity needed for this test."
    )

    self.measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTStorageMetric(), XCTMemoryMetric()]) {
      Task.init() {
        do {
          try await sut.requestCategoriesData()
        } catch {
          XCTFail("Error in testPerformanceApiRequest()")
        }
      }
    }
  }
}
