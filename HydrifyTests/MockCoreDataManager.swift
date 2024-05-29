//
//  MockCoreDataManager.swift
//  HydrifyTests
//
//  Created by Dhawal Mahajan on 29/05/24.
//

import Foundation
@testable import Hydrify
class MockCoreDataManager: CoreDataManaging {
    var logEntries: [WaterLog] = []

    func createLogEntry(date: Date, quantity: Double, unit: String) -> WaterLog? {
        let log = WaterLog(entity: WaterLog.entity(), insertInto: nil)
        log.id = UUID()
        log.date = date
        log.quantity = quantity
        log.unit = unit
        logEntries.append(log)
        return log
    }

    func fetchAllEntries() -> [WaterLog] {
        return logEntries
    }

    func updateLogEntry(entry: WaterLog, date: Date, newQuantity: Double, unit: String) {
        if let index = logEntries.firstIndex(where: { $0.id == entry.id }) {
            logEntries[index].date = date
            logEntries[index].quantity = newQuantity
            logEntries[index].unit = unit
        }
    }

    func deleteLogEntry(entry: WaterLog) {
        if let index = logEntries.firstIndex(where: { $0.id == entry.id }) {
            logEntries.remove(at: index)
        }
    }
}
