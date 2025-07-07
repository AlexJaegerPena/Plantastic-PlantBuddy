//
//  WateringTaskCal.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 27.06.25.
//

import Foundation

struct WateringTaskCal: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd"
        return formatter
    }()
    
    
}
