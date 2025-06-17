//
//  TimesWatered.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 16.06.25.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

struct WateringRecord: Codable, Identifiable {
    
    @DocumentID var id: String?
    var timestamp: Timestamp

}
