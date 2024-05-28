//
//  DailyWaterLogViewModel.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 26/05/24.
//

import UIKit
import CoreData
enum Unit: String {
    case glass
    case bottle
}
class DailyWaterLogViewModel {
    @Published var waterLog: [WaterLog] = []
    let allUnits: [Unit] = [.glass,.bottle]
    
    func fetchLogsForToday() {
        let fetchRequest: NSFetchRequest<WaterLog> = WaterLog.fetchRequest()
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as? NSDate ?? NSDate())
        
        do {
            waterLog = try PersistentStorage.shared.context.fetch(fetchRequest)
            PersistentStorage.shared.saveContext()
        } catch {
            print("Failed to fetch logs: \(error)")
        }
    }
    func addLog(date: Date, quantity: Double, unit: String) {
        
        let newLog = WaterLog(context: PersistentStorage.shared.context)
        newLog.id = UUID()
        newLog.date = date
        newLog.quantity = quantity
        newLog.unit = unit
        waterLog.append(newLog)
        PersistentStorage.shared.saveContext()
    }
    
    func getDailyTotal() -> String{
        let total = waterLog.reduce(0) { $0 + $1.quantity }
        return "Total: \(total) liters"
    }
    func updateLog(log: WaterLog, quantity: Double, unit: String, date: Date) {
//        if let index = waterLog.firstIndex(where: { $0.id == log.id }) {
//            waterLog[index].date = date
//            waterLog[index].quantity = quantity
//            waterLog[index].unit = unit
//        }
        log.date = date
              log.quantity = quantity
              log.unit = unit
        PersistentStorage.shared.saveContext()
        fetchLogsForToday()
        
        
    }
    func deleteLog(log: WaterLog) {
//        waterLog.removeAll { $0.id == log.id }
        PersistentStorage.shared.context.delete(log)
        PersistentStorage.shared.saveContext()
        fetchLogsForToday()
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
}

extension DailyWaterLogViewModel {
    func getNumberOfRows() -> Int {
        return waterLog.count
    }
    func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = waterLog[indexPath.row].unit
       
        return cell
    }
   
}
