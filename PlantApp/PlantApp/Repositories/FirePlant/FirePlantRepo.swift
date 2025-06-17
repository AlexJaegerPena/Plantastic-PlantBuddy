//
//  FirePlantRepo.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 16.06.25.
//

import Foundation
import FirebaseFirestore


class FirePlantRepo {

    private let userId: String
    private let db: Firestore = FirebaseManager.shared.database

    init(userId: String) {
        self.userId = userId
    }

    
    func add(plant: FirePlant) async throws -> String {
        
        print("Fireplant repo userId: \(userId)")
                
        // addDocument(from:) gibt eine DocumentReference zurück
        let docRef = try db.collection("users").document(userId).collection("favoritePlants").addDocument(from: plant)

        let newDocumentID = docRef.documentID
        print("Fireplant repo plantId (after add): \(newDocumentID)") // generierte ID

        return newDocumentID
    }

    
    func fetchFavorites() async throws -> [FirePlant] {
        let snapshot = try await db.collection("users").document(userId).collection("favoritePlants").getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: FirePlant.self) }
    }
    

    
    func remove(plantId: String) async throws {
        try await db.collection("users").document(userId).collection("favoritePlants").document(plantId).delete()
        print("Pflanze erfolgreich entfernt")
    }

    
    func trackWatering(for plant: FirePlant, record: WateringRecord) async throws {
        
        guard let plantId = plant.id else {
                throw NSError(domain: "FirePlantRepo", code: 0, userInfo: [NSLocalizedDescriptionKey: "Plant ID ist leer. Kann Bewässerungsdaten nicht zuordnen."])
            }
        
        try db.collection("users").document(userId) // Benutzer-Dokument
                      .collection("favoritePlants").document(plantId) // favorisierte Pflanze
                      .collection("timesWatered") // Sub-Sammlung für Bewässerungszeiten
                      .addDocument(from: record)
    }
    
    
    func addFavSnapshotListener(userId: String, onChange: @escaping ([FirePlant]) -> Void) -> ListenerRegistration? {
            db.collection("users").document(userId)
                .collection("favoritePlants")
                .addSnapshotListener { querySnapshot, error in
                    if let error {
                        print("Fehler beim Abrufen der Favoriten (Listener): \(error.localizedDescription)")
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("Keine Dokumente im Snapshot (Favoriten-Listener).")
                        return }
                    
                    let favPlants = documents.compactMap { snapshot in
                        
                        try? snapshot.data(as: FirePlant.self)
                    }
                    DispatchQueue.main.async {
                                    onChange(favPlants)
                                }
                }
        }

    
    
}
