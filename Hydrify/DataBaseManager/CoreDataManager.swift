//
//  CoreDataManager.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 28/05/24.
//

import Foundation
import CoreData
class CoreDataManager {
    func createLogEntry(date: Date, quantity: Double, unit: String) -> WaterLog? {
        let newLogEntry = WaterLog(entity: WaterLog.entity(), insertInto: PersistentStorage.shared.context)
    newLogEntry.id = UUID()
      newLogEntry.date = date
      newLogEntry.quantity = quantity
      newLogEntry.unit = unit
      
      do {
        try PersistentStorage.shared.context.save()
        return newLogEntry
      } catch {
        print("Error saving new log entry: \(error)")
        return nil
      }
    }

    func fetchAllEntries() -> [WaterLog] {
      let context = PersistentStorage.shared.context
        let fetchRequest: NSFetchRequest<WaterLog> = WaterLog.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as? NSDate ?? NSDate())
        
      do {
        let entries = try context.fetch(fetchRequest)
        return entries
      } catch {
        print("Error fetching log entries: \(error)")
        return []
      }
    }
    
    func updateLogEntry(entry: WaterLog, date: Date, newQuantity: Double, unit: String) {
      let context = PersistentStorage.shared.context
      entry.quantity = newQuantity
        entry.date = date
        entry.unit = unit
      
      do {
        try context.save()
      } catch {
        print("Error updating log entry: \(error)")
      }
    }
    func deleteLogEntry(entry: WaterLog) {
      let context = PersistentStorage.shared.context
      context.delete(entry)
      
      do {
        try context.save()
      } catch {
        print("Error deleting log entry: \(error)")
      }
    }
}
