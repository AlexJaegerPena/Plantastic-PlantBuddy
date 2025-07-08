//
//  CalendarHeaderView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 27.06.25.
//

import SwiftUI

import SwiftUI

struct CalendarHeaderView: View {
    
    @Binding var displayedMonth: Date
    @State private var selectedDate: Date? = nil

    let calendar = Calendar.current
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f
    }()
    
    // Wochentage anzeigen
    var weekdays: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        return Array(symbols[1...6] + [symbols[0]])  // SUN ans ende des Arrays stellen
    }
    
    // Den heutigen Tag anzeigen
    var todayWeekdayIndex: Int {
        let originalIndex = calendar.component(.weekday, from: Date()) - 1
        return (originalIndex + 6) % 7
    }
    
    var body: some View {
        
        VStack(spacing: 24) {
            HStack {
                Button(action: { changeMonth(by: -1) }) { Image(systemName: "chevron.left") }
                Spacer()
                Text(formatter.string(from: displayedMonth))
                    .font(.headline)
                Spacer()
                Button(action: { changeMonth(by: 1) }) { Image(systemName: "chevron.right") }
            }
            .tint(.primary)
            .padding(.horizontal)
            
            HStack(spacing: 2) {
                ForEach(weekdays.indices, id: \.self) { index in
                    Text(weekdays[index])
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity)
//                        .foregroundStyle(index == todayWeekdayIndex ? .primary : .gray)
                        .padding(.vertical, 3)
                        .background(index == todayWeekdayIndex ? Color("secondaryPetrol").opacity(0.4) : Color("secondaryPetrol").opacity(0.2), in: .rect(cornerRadius: 8))
                }
            }
        }
        }
        
    // angezeigten Monat ändern
    func changeMonth(by value: Int) {
        displayedMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) ?? displayedMonth
    }
    
    func generateMonthGrid() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else { return [] }
        return stride(from: firstWeek.start, through: lastWeek.end, by: 86400).map { $0 }
    }
        
}

#Preview {
    CalendarHeaderView(displayedMonth: .constant(Date()))
}
