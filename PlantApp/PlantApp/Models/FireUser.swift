//
//  User.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 28.05.25.
//

import Foundation
import FirebaseFirestore

struct FireUser: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    var username: String
    var email: String
    var password: String
    var favoritePlants: [FirePlant]
}
