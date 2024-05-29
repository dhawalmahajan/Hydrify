//
//  HydrationLogViewModel.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 28/05/24.
//

import UIKit
enum Unit: String {
    case glass
    case bottle
}
class HydrationLogViewModel: ObservableObject {
    let allUnits: [Unit] = [.glass,.bottle]
    @Published private(set) var entries: [WaterLog] = []
    @Published var quantity: Double = 0.0
    @Published var unit: Unit = .glass
    @Published var totalDailyIntake: Double = 0.0
    private let coreDataManager: CoreDataManaging
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    init(coreDataManager: CoreDataManaging) {
        self.coreDataManager = coreDataManager
        fetchEntries()
        calculateTotalIntake()
    }
    
    func fetchEntries() {
        entries = coreDataManager.fetchAllEntries()
        calculateTotalIntake()
    }
    
    func addEntry(date: Date, quantity: Double, unit: String) {
        //    guard newQuantity > 0 else { return }
        _ = coreDataManager.createLogEntry(date: date, quantity: quantity, unit: unit)
        fetchEntries()
        resetNewEntryValues()
        calculateTotalIntake()
    }
    
    func updateEntry(entry: WaterLog,date: Date, newQuantity: Double, unit: String) {
        coreDataManager.updateLogEntry(entry: entry, date: date, newQuantity: newQuantity, unit: unit)
        fetchEntries()
    }
    
    func deleteEntry(entry: WaterLog) {
        coreDataManager.deleteLogEntry(entry: entry)
        fetchEntries()
    }
    
    private func resetNewEntryValues() {
        quantity = 0.0
        unit = .glass
    }
    
    
    func scheduleHydrationReminder() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Hydration Reminder"
        content.body = "Don't forget to drink water!"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "HydrationReminder", content: content, trigger: trigger)
        center.add(request)
    }
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                self.scheduleHydrationReminder()
            }
        }
    }
    private func calculateTotalIntake() {
        totalDailyIntake = entries.reduce(0.0) { sum, entry in
            var convertedQuantity = entry.quantity
            // Convert quantity based on measure (assuming conversion factors)
            switch entry.unit {
            case "glass":
                convertedQuantity *= 250.0 // Milliliters in a glass (example)
            case "bottle":
                convertedQuantity *= 500.0 // Milliliters in a bottle (example)
            default:
                break
            }
            return sum + convertedQuantity
        }
        totalDailyIntake /= 1000.0 // Convert milliliters to liters
    }
}

