//
//  CalendarView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct CalendarView: View {
    
    let calendar = Calendar.current
    let today = Date()
    
    var currentMonthDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }


    
    
    
    @State private var selectedDate = Date()
    
    var body: some View {
        DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
            .datePickerStyle(.graphical)
    }
}

#Preview {
    CalendarView()
}
