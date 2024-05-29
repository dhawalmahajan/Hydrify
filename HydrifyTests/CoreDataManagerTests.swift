//
//  CoreDataManagerTests.swift
//  HydrifyTests
//
//  Created by Dhawal Mahajan on 29/05/24.
//

import XCTest
@testable import Hydrify
class CoreDataManagerTests: XCTestCase {
    
    var coreDataManager: CoreDataManaging!
    
    override func setUp() {
        super.setUp()
        coreDataManager = MockCoreDataManager()
    }
    
    override func tearDown() {
        coreDataManager = nil
        super.tearDown()
    }
    
    func testCreateLogEntry() {
        // Given
        let date = Date()
        let quantity = 500.0
        let unit = "ml"
        
        // When
        let logEntry = coreDataManager.createLogEntry(date: date, quantity: quantity, unit: unit)
        
        // Then
        XCTAssertNotNil(logEntry)
        XCTAssertEqual(logEntry?.date, date)
        XCTAssertEqual(logEntry?.quantity, quantity)
        XCTAssertEqual(logEntry?.unit, unit)
    }
    
    func testFetchAllEntries() {
        // Given
        let date = Date()
        let quantity = 500.0
        let unit = "ml"
        coreDataManager.createLogEntry(date: date, quantity: quantity, unit: unit)
        
        // When
        let entries = coreDataManager.fetchAllEntries()
        
        // Then
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.date, date)
        XCTAssertEqual(entries.first?.quantity, quantity)
        XCTAssertEqual(entries.first?.unit, unit)
    }
    
    func testUpdateLogEntry() {
        // Given
        let date = Date()
        let quantity = 500.0
        let unit = "ml"
        let logEntry = coreDataManager.createLogEntry(date: date, quantity: quantity, unit: unit)
        
        // When
        let newDate = Date().addingTimeInterval(1000)
        let newQuantity = 1000.0
        let newUnit = "L"
        coreDataManager.updateLogEntry(entry: logEntry!, date: newDate, newQuantity: newQuantity, unit: newUnit)
        
        // Then
        let updatedEntry = coreDataManager.fetchAllEntries().first
        XCTAssertEqual(updatedEntry?.date, newDate)
    }
}
