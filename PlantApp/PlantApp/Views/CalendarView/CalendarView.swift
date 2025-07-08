//
//  CalendarView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var favPlantViewModel: FavPlantViewModel
    
    @State var displayedMonth: Date = Date()
    @State var selectedDate: Date? = nil
    
    let calendar = Calendar.current


    var body: some View {
        VStack {
            Text("When’s Watering Day?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 30)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color("primaryPetrol"))
            
            CalendarHeaderView(displayedMonth: $displayedMonth)
            let days = generateMonthGrid()
            
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 2) {
                ForEach(days, id: \.self) { date in
                    
                    let isCurrentMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
                    //                let tasksForDay = tasks.filter { calendar.isDate($0.date, inSameDayAs: date)}
                    let isSelected = selectedDate != nil && calendar.isDate(selectedDate ?? date, inSameDayAs: date)
                    
                    VStack(spacing: 4) {
                        Text("\(calendar.component(.day, from: date))")
                            .font(.system(size: 15))
                            .frame(maxWidth: .infinity, minHeight: 45)
                            .foregroundStyle(isSelected ? .white : (isCurrentMonth ? .primary : .gray))
                            .background(isSelected ? Color("primaryPetrol") : isCurrentMonth ? Color("bgColor") : Color("bgColor").opacity((0.2)))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(Calendar.current.isDateInToday(date) ? Color.primary : .clear)
                                    .padding(1)
                            }
                            .overlay(alignment: .bottom) {
                                HStack(spacing: 3) {
                                    let tasksForThisDate = favPlantViewModel.futureWateringTasks.filter {
                                        // Datum der Aufgabe mit dem Datum des Kalendertags vergleichen
                                        task in
                                        Calendar.current.isDate(task.date, inSameDayAs: date)
                                    }
                                    let limitedTasksForDisplay = tasksForThisDate.prefix(1)
                                    
                                    ForEach(limitedTasksForDisplay) { task in
                                        Image(systemName: "drop.fill")
                                            .font(.system(size: 12))
                                            .padding(.bottom, 2)
                                            .foregroundStyle(isSelected ? .white : Color("secondaryPetrol"))
                                    }
                                }
                            }
                    }
                    .onTapGesture {
                        if let selected = selectedDate, calendar.isDate(selected, inSameDayAs: date) {
                            selectedDate = nil
                        } else {
                            selectedDate = date
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 5)
            Spacer()
        }
    }

    
    func generateMonthGrid() -> [Date] {
        // Startpunkt für Kalender bestimmen
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              // Start der ersten Woche & Ende der letzten Woche, die den Monat berühren
              let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1) // -1 Sek weil .end immer auf Mitternacht des nächsten Monats zeigt
        else { return [] }
        // Generiert alle Tage in 1-Tages-Schritten (86400 Sekunden = 24 Stunden)
        return stride(from: firstWeek.start, through: lastWeek.end, by: 86400).map { $0 }
    }
}


#Preview {
    CalendarView(displayedMonth: Date())
        .environmentObject(FavPlantViewModel())
}
