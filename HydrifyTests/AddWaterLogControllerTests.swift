//
//  AddWaterLogControllerTests.swift
//  HydrifyTests
//
//  Created by Dhawal Mahajan on 29/05/24.
//

import XCTest
@testable import Hydrify
final class AddWaterLogControllerTests: XCTestCase {
    var sut: AddWaterLogController!
       var mockHydrationLogViewModel: MockHydrationLogViewModel!
       var mockAddWaterLogViewModel: MockAddWaterLogViewModel!

       override func setUp() {
           super.setUp()
           mockHydrationLogViewModel = MockHydrationLogViewModel(coreDataManager: MockCoreDataManager())
           mockAddWaterLogViewModel = MockAddWaterLogViewModel()
           sut = AddWaterLogController(waterlogViewModel: mockHydrationLogViewModel)
//           sut.addWaterlogViewModel = mockAddWaterLogViewModel
           sut.loadViewIfNeeded()
       }

       override func tearDown() {
           sut = nil
           mockHydrationLogViewModel = nil
           mockAddWaterLogViewModel = nil
           super.tearDown()
       }

       func testSaveLog_AddsNewLog_WhenFormIsValid() {
           // Arrange
           sut.quantityTextField.text = "500"
           sut.unitTextField.text = "ml"
           sut.addWaterlogViewModel.selectedDate = Date()

           // Act
           sut.saveLog()

           // Assert
           XCTAssertTrue(mockHydrationLogViewModel.addEntryCalled)
       }

       func testSaveLog_UpdatesLog_WhenFormIsValidAndLogIsPresent() {
           // Arrange
           let log = WaterLog()
           sut.log = log
           sut.quantityTextField.text = "500"
           sut.unitTextField.text = "ml"
           sut.addWaterlogViewModel.selectedDate = Date()

           // Act
           sut.saveLog()

           // Assert
           XCTAssertTrue(mockHydrationLogViewModel.updateEntryCalled)
       }

       func testSaveLog_ShowsAlert_WhenFormIsInvalid() {
           // Arrange
           let alertVerifier = AlertVerifier()
           sut.quantityTextField.text = ""
           sut.unitTextField.text = ""

           // Act
           sut.saveLog()

           // Assert
           XCTAssertEqual(alertVerifier.presentedCount, 1)
           XCTAssertEqual(alertVerifier.title, "Failed")
           XCTAssertEqual(alertVerifier.message, "Please fill form correctly!")
       }

}

private class AlertVerifier {
    private(set) var presentedCount = 0
    private(set) var title: String?
    private(set) var message: String?
    private(set) var actions = [UIAlertAction]()

    init() {
        swizzlePresent()
    }

    deinit {
        swizzlePresent()
    }

    @objc func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let alertController = viewControllerToPresent as? UIAlertController {
            presentedCount += 1
            title = alertController.title
            message = alertController.message
            actions = alertController.actions
        }
    }

    private func swizzlePresent() {
        let original = #selector(UIViewController.present(_:animated:completion:))
        let swizzled = #selector(AlertVerifier.present(_:animated:completion:))
        let originalMethod = class_getInstanceMethod(UIViewController.self, original)!
        let swizzledMethod = class_getInstanceMethod(AlertVerifier.self, swizzled)!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
