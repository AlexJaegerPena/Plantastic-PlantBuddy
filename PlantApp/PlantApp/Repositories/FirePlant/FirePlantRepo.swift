//
//  FirePlantRepo.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 16.06.25.
//

import FirebaseFirestore
import Foundation

class FirePlantRepo {

    private let userId: String
    private let db: Firestore = FirebaseManager.shared.database

    init(userId: String) {
        self.userId = userId
    }

    func add(plant: FirePlant) async throws -> String {

        print("Fireplant repo userId: \(userId)")

        // addDocument(from:) gibt eine DocumentReference zurück
        let docRef = try db.collection("users").document(userId).collection(
            "favoritePlants"
        ).addDocument(from: plant)

        let newDocumentID = docRef.documentID
        print("Fireplant repo plantId (after add): \(newDocumentID)")  // generierte ID

        return newDocumentID
    }
    
    func fetchFavorites() async throws -> [FirePlant] {
        let snapshot = try await db.collection("users").document(userId)
            .collection("favoritePlants").getDocuments()
        return snapshot.documents.compactMap {
            try? $0.data(as: FirePlant.self)
        }
    }

    func remove(plantId: String) async throws {
        try await db.collection("users").document(userId).collection(
            "favoritePlants"
        ).document(plantId).delete()
        print("Pflanze erfolgreich entfernt")
    }

    func trackWateringRecord(for plant: FirePlant, record: WateringRecord) async throws {
        guard let plantId = plant.id else {
            throw NSError(
                domain: "FirePlantRepo", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Plant ID ist leer. Kann Bewässerungsdaten nicht zuordnen."
                ])
        }

        // Neue Bewässerung hinzufügen
        try db
            .collection("users").document(userId)  // Benutzer-Dokument
            .collection("favoritePlants").document(plantId)  // favorisierte Pflanze
            .collection("timesWatered")  // Sub-Sammlung für Bewässerungszeiten
            .addDocument(from: record)

        // 2. lastWaterDate und nextWaterDate im Haupt-Pflanzendokument aktualisieren
        // Das Datum der letzten Bewässerung ist der Zeitpunkt dieses Records
        let newLastWaterDate = record.date

        // Berechne das nextWaterDate
        let newNextWaterDate: Date?

        // Holen des Bewässerungsintervalls (in Tagen) aus den Pflanzendetails
        let wateringIntervalDays = Int(plant.watering?.nextWatering ?? 7)

        // Berechne das nächste Bewässerungsdatum basierend auf der aktuellen Bewässerung
        newNextWaterDate = Calendar.current.date(
            byAdding: .day, value: wateringIntervalDays, to: newLastWaterDate)

        // Erstelle ein Dictionary der Felder, die aktualisiert werden sollen
        var updatedFields: [String: Any] = [
            "lastWaterDate": newLastWaterDate
        ]

        // newNextWaterDate ist ein Optional. Es muss sicher ausgepackt werden,
        // bevor es dem [String: Any] Dictionary zugewiesen wird.
        if let nextDate = newNextWaterDate {
            updatedFields["nextWaterDate"] = nextDate
        }

        // Führe das Update im Haupt-Pflanzendokument aus
        try await db
            .collection("users").document(userId)
            .collection("favoritePlants").document(plantId)
            .updateData(updatedFields)  // updateData ist hier die richtige Wahl, um nur spezifische Felder zu ändern

        print(
            "Pflanze mit ID '\(plantId)' erfolgreich bewässert und Daten aktualisiert."
        )
        print("Neues lastWaterDate: \(newLastWaterDate)")
        print("Neues nextWaterDate: \(newNextWaterDate?.description ?? "nil")")  // Füge description hinzu, um das Datum lesbar zu machen
    }

    func update(plant: FirePlant) async throws {
        guard let plantId = plant.id else {
            throw NSError(
                domain: "FirePlantRepo", code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Plant ID ist leer. Kann Pflanze nicht aktualisieren."
                ])
        }

        let plantData = try Firestore.Encoder().encode(plant)

        try await db.collection("users").document(userId)
            .collection("favoritePlants").document(plantId)
            .setData(plantData, merge: true)  //merge um nur die übergebenen felder zu aktualisieren
    }

    func addFavSnapshotListener(
        userId: String, onChange: @escaping ([FirePlant]) -> Void
    ) -> ListenerRegistration? {
        db.collection("users").document(userId)
            .collection("favoritePlants")
            .addSnapshotListener { querySnapshot, error in
                if let error {
                    print(
                        "Fehler beim Abrufen der Favoriten (Listener): \(error.localizedDescription)"
                    )
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("Keine Dokumente im Snapshot (Favoriten-Listener).")
                    return
                }

                let favPlants = documents.compactMap { snapshot in

                    try? snapshot.data(as: FirePlant.self)
                }
                DispatchQueue.main.async {
                    onChange(favPlants)
                }
            }
    }
    
//    func fetchFavDetailsByID(_ id: String ) async throws -> FirePlant {
//        
//    }
 
}
