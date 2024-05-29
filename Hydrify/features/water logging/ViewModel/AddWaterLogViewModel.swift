//
//  AddWaterLogViewModel.swift
//  Hydrify
//
//  Created by Dhawal Mahajan on 29/05/24.
//

import Foundation
import SwiftUI
class AddWaterLogViewModel {
    @Published var selectedDate: Date = Date()
    
     func isFormFilledValid(qunatity: String?, unit:String?, date: String?) -> Bool{
        if  qunatity == nil || qunatity?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            return false
        }
        if unit == nil || unit?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            return false
        }
         if date == nil || date?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
             return false
         } 
        return true
    }
    
    func convertStringFromDateToDate() -> Date? {
        let formattedString =  formatDateToString(date: selectedDate)
        let newDate =  convertStringToDate(stringDate: formattedString)
        return newDate
    }
    func formatDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
    
    func convertStringToDate(stringDate: String) -> Date? {
          let formatter = DateFormatter()
          formatter.dateFormat = "MM/dd/yyyy"
          return formatter.date(from: stringDate)
        }
}
