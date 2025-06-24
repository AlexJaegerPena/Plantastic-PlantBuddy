//
//  TimesWatered.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 16.06.25.
//

import Foundation
import FirebaseFirestore

struct WateringRecord: Codable, Identifiable {
    
    @DocumentID var id: String?
    var date: Date
}
