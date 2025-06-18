//
//  FavPlantViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 16.06.25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore



@MainActor
class FavPlantViewModel: ObservableObject {
    
    @Published var favPlantsList: [FirePlant] = []
    @Published var selectedFavPlant: FirePlant?
    @Published var searchTerm: String = ""
    @Published var plantSuggestionList: [FirePlant] = []
    @Published var listErrorMessage: String?
    
    // Private Task-Variable für die Debounce-Logik
    private var searchTask: Task<Void, Error>?
    private var listener: ListenerRegistration?
    

    private let userId: String?
    private let repo: FirePlantRepo
    private let fireManager = FirebaseManager.shared


    // beim Erstellen des ViewModels userId an Repo weiterleiten
//    init(userId: String) {
//        self.userId = userId
//        self.repo = FirePlantRepo(userId: userId)
//    }
//    
    init() {
        self.userId = fireManager.userID
        self.repo = FirePlantRepo(userId: self.userId ?? "")
        self.addSnapshotListener()
        }
    
    deinit {
        listener?.remove() // Listener beim Zerstören des ViewModels entfernen
    }

    
    func loadFavorites() async {
        do {
            favPlantsList = try await repo.fetchFavorites()
        } catch {
            print("Fehler beim Laden:", error)
        }
    }

    
    func addToFavorites(_ plant: FirePlant) async {
        print("test")
        print("FavPlantViewModel userId: \(String(describing: userId))")
        print(plant.commonName)
        do {
            let generatedId = try await repo.add(plant: plant)
            print("Pflanze \(plant.commonName) zu Favoriten hinzugefügt.")
            print(favPlantsList)
            await loadFavorites()
            print(favPlantsList)
        } catch {
            print("Fehler beim Hinzufügen:", error)
        }
    }

    
    func removeFromFavorites(plantId: String) async {
        do {
            try await repo.remove(plantId: plantId)
            await loadFavorites()
        } catch {
            print("Fehler beim Entfernen:", error)
        }
    }
    
    
    func addSnapshotListener() {
        
        guard let userId = self.userId else {
            print("User id nicht gefunden. Snapshot listener nicht gestartet")
            return
        }
        
        self.listener = repo.addFavSnapshotListener(userId: userId) { [weak self] favPlantsList in
            self?.favPlantsList = favPlantsList.sorted { plant1, plant2 in
                plant1.commonName > plant2.commonName}
        }
    }

    
    // Watering logic
    func trackWatering(for plant: FirePlant, with id: String?) async {
        
//        guard let id else { return }
        
        let newRecord = WateringRecord(timestamp: Timestamp(date: Date()))
        
        do {
            try await repo.trackWatering(for: plant, record: newRecord)
        } catch {
            print("Fehler beim Watering:", error)
        }
    }
    
    
    func updatePlant(for plant: FirePlant, with id: String?) async {
        
//        guard let id else { return }
        
        
        
    }
    
}



