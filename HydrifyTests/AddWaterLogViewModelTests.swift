//
//  AddWaterLogViewModelTests.swift
//  HydrifyTests
//
//  Created by Dhawal Mahajan on 29/05/24.
//

import XCTest
@testable import Hydrify
class MockAddWaterLogViewModel: AddWaterLogViewModel {
    override func isFormFilledValid(qunatity: String?, unit: String?, date: String?) -> Bool {
        return !(qunatity?.isEmpty ?? true) && !(unit?.isEmpty ?? true) && !(date?.isEmpty ?? true)
    }
}
final class AddWaterLogViewModelTests: XCTestCase {
    var viewModel: MockAddWaterLogViewModel!
    override func setUpWithError() throws {
        viewModel = MockAddWaterLogViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    func testIsFormFilledValid() {
            // Test when all fields are valid
            XCTAssertTrue(viewModel.isFormFilledValid(qunatity: "500", unit: "glass", date: "05/29/2024"))
            
            // Test when quantity is nil
            XCTAssertFalse(viewModel.isFormFilledValid(qunatity: nil, unit: "bottle", date: "05/29/2024"))
            
            // Test when quantity is empty
            XCTAssertFalse(viewModel.isFormFilledValid(qunatity: "", unit: "glass", date: "05/29/2024"))
            
            // Test when unit is nil
            XCTAssertFalse(viewModel.isFormFilledValid(qunatity: "500", unit: nil, date: "05/29/2024"))
            
            // Test when unit is empty
            XCTAssertFalse(viewModel.isFormFilledValid(qunatity: "500", unit: "", date: "05/29/2024"))
            
            // Test when date is nil
            XCTAssertFalse(viewModel.isFormFilledValid(qunatity: "500", unit: "glass", date: nil))
            
            // Test when date is empty
            XCTAssertFalse(viewModel.isFormFilledValid(qunatity: "500", unit: "bottle", date: ""))
        }
    func testFormatDateToString() {
            // Given
            let date = Date(timeIntervalSince1970: 0) // 01/01/1970
            
            // When
            let dateString = viewModel.formatDateToString(date: date)
            
            // Then
            XCTAssertEqual(dateString, "01/01/1970")
        }
        
        func testConvertStringToDate() {
            // Given
            let dateString = "01/01/1970"
            
            // When
            let date = viewModel.convertStringToDate(stringDate: dateString)
            
            // Then
            XCTAssertNotNil(date)
            
            // Verify the components of the date
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: date!)
            XCTAssertEqual(components.year, 1970)
            XCTAssertEqual(components.month, 1)
            XCTAssertEqual(components.day, 1)
        }
        
        func testConvertStringFromDateToDate() {
            // Given
            viewModel.selectedDate = Date(timeIntervalSince1970: 0) // 01/01/1970
            
            // When
            let newDate = viewModel.convertStringFromDateToDate()
            
            // Then
            XCTAssertNotNil(newDate)
            
            // Verify the components of the new date
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: newDate!)
            XCTAssertEqual(components.year, 1970)
            XCTAssertEqual(components.month, 1)
            XCTAssertEqual(components.day, 1)
        }
}
