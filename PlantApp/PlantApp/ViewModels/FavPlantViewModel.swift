//
//  FavPlantViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 16.06.25.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore



@MainActor
class FavPlantViewModel: ObservableObject {
    
    @Published var favPlantsList: [FirePlant] = [] {
        didSet { // Property Observer mit comp property
            plantsNeedWaterToday = favPlantsList.contains(where: { $0.needsToBeWatered })
            if plantsNeedWaterToday {
                print("A plant needs water today")
            } else {
                print("No plant needs water today")
            }
        }
    }
    @Published var selectedFavPlant: FirePlant?
    @Published var selectedFavPlantId: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var plantsNeedWaterToday: Bool = false
    @Published var isFavorite: Bool = true

    
    var futureWateringTasks: [WateringTaskCal] {
        var tasks: [WateringTaskCal] = []
        for plant in favPlantsList {
            if let nextDate = plant.nextWaterDate {
                let task = WateringTaskCal(date: nextDate, title: plant.commonName)
                tasks.append(task)
            }
        }
        return tasks
    }
    
    var allWateringsCount: Double {
        var total: Double = 0.0
        for plant in favPlantsList {
            if plant.waterings != nil {
                total += Double(plant.waterings?.count ?? 0)
            }
        }
        return total
    }    

    
    private var listener: ListenerRegistration?
    private let userId: String?
    private let repo: FirePlantRepo
    private let fireManager = FirebaseManager.shared


    init() {
        self.userId = fireManager.userID
        self.repo = FirePlantRepo(userId: self.userId ?? "") // Initialisiere repo mit aktueller userId
        
        self.addSnapshotListener()
        Task {
               await loadFavorites()
           }
        }
    
    deinit {
        listener?.remove() // Listener beim Zerstören des ViewModels entfernen
    }

    
    func loadFavorites() async {
        guard let userId = self.userId, !userId.isEmpty else {
            print("Keine UserId zum Laden der Favoriten gefunden")
            self.errorMessage = "Authentification error: User ID missing."
            return
        }
        do {
            favPlantsList = try await repo.fetchFavorites(userId)
        } catch {
            print("Fehler beim Laden:", error)
        }
    }
    
    func loadSelectedFav(_ plantId: String) async {
        guard !isLoading else { return } // Verhindert doppeltes Laden
        
        isLoading = true
        errorMessage = nil
        selectedFavPlant = nil // alten Detailzustand löschen
        
        guard let currentUserId = self.userId, !currentUserId.isEmpty else {
            print("Keine UserId zum Laden der Favoriten gefunden")
            self.errorMessage = "Authentification error: User ID missing."
            isLoading = false
            return
        }
        
        defer { isLoading = false} // Stellt sicher, dass isLoading immer auf false gesetzt wird

            do {
                let fetchedPlant = try await repo.fetchPlant(userId: currentUserId, plantId: plantId)
                
                self.selectedFavPlant = fetchedPlant // Ergebnis der neuen @Published Property zuweisen
                
                if fetchedPlant == nil {
                    print("Pflanze mit ID \(plantId) nicht in Favoriten gefunden.")
                    self.errorMessage = "Plant not found"
                } else {
                    print("Pflanze \(fetchedPlant!.commonName) erfolgreich geladen.")
                }
            } catch {
                print("Fehler beim Laden:", error)
                self.errorMessage = "Loading of plant failed: \(error.localizedDescription)"
            }
    }
    
    

    func addToFavorites(_ plant: FirePlant) async {
        guard let userId = self.userId, !userId.isEmpty else {
            print("Keine UserId zum Hinzufügen der Favoriten gefunden")
            return
        }
        do {
            let addedPlantID = try await repo.add(plant: plant)
            print("Pflanze \(plant.commonName) mit ID \(addedPlantID) zu Favoriten hinzugefügt.")
            print(favPlantsList)
//            await loadFavorites()
            print(favPlantsList)
        } catch {
            print("Fehler beim Hinzufügen:", error)
        }
    }
    
    func removeFromFavorites(plantId: String) async {
        guard let userId = self.userId, !userId.isEmpty else {
            print("Keine UserId zum Entfernen der Favoriten gefunden")
            return
        }
        do {
            try await repo.remove(plantId: plantId)
//            await loadFavorites()
        } catch {
            print("Fehler beim Entfernen:", error)
        }
    }
    
    // FavPlants aktualisieren
    func addSnapshotListener() {
        guard let userId = self.userId, !userId.isEmpty else {
            print("User id nicht gefunden. Snapshot listener nicht gestartet")
            return
        }
        self.listener = repo.addFavSnapshotListener(userId: userId) { [weak self] favPlantsList in
            self?.favPlantsList = favPlantsList.sorted { plant1, plant2 in
                plant1.commonName > plant2.commonName}
        }
    }

    
    // Watering logic
    func addWatering(for plant: FirePlant, with id: String?) async  {
        guard let userId = self.userId, !userId.isEmpty else {
            print("User id nicht gefunden. Snapshot listener nicht gestartet")
            return
        }
        
        guard let id else { return }
        
        let newRecord = WateringRecord(date: Date())
        var updatedPlant = plant
        
        // leeres Array erstellen
        if updatedPlant.waterings == nil {
            updatedPlant.waterings = []
        }
        updatedPlant.waterings?.append(newRecord)
        updatedPlant.lastWaterDate = newRecord.date
        print("nextWaternig \(String(describing: updatedPlant.nextWaterDate))")
        
        // nextWaterDate neu berechnen
        if let wateringIntervalDays = plant.watering?.nextWatering {
            updatedPlant.nextWaterDate = Calendar.current.date(byAdding: .day, value: Int(wateringIntervalDays), to: updatedPlant.lastWaterDate!)
            print("nextWaternig \(String(describing: updatedPlant.nextWaterDate))")
        } else {
            updatedPlant.nextWaterDate = Calendar.current.date(byAdding: .day, value: 7, to: updatedPlant.lastWaterDate ?? Date()) // fallback in 7 Tagen
    }
        do {
            // zur subcollection hinzufügen
            try await repo.trackWateringRecord(for: plant, record: newRecord)
            print("Pflanze erfolgreich bewässert")
            // needsToBeWateredDate muss nicht aktualisiert werden, da berechnete Property
            // plant in der datenbank aktualisieren
            await updatePlant(for: updatedPlant, with: id)
            
            self.selectedFavPlant = updatedPlant

            } catch {
                print("Fehler beim Watering:", error)
            }

    }
    
    
    func updatePlant(for plant: FirePlant, with id: String?) async {
        guard let userId = self.userId, !userId.isEmpty else {
            print("User id nicht gefunden. Snapshot listener nicht gestartet")
            return
        }
        
        do {
        try await repo.update(plant: plant)
        print("Pflanze \(plant.commonName) erfolgreich aktualisiert")
        } catch {
        print("Fehler beim Aktualisieren der Pflanze:", error)
        }
    }
    
    
    // ------- Dummy Data -------
    let dummyFavPlants: [FirePlant] = {
        let calendar = Calendar.current
        let today = Date()

        // --- Pflanze 1: Needs Water (überfällig) ---
        var plant1 = FirePlant(
            id: "fp_dummy_1",
            apiPlantId: 101,
            commonName: "Peace Lily",
            scientificName: ["Spathiphyllum wallisii"],
            family: "Araceae",
            genus: "Spathiphyllum",
            type: "Houseplant",
            dimensions: [DimensionItem(minValue: 0.3, maxValue: 0.6, unit: "meter")],
            watering: Watering(rawValue: "Average"), // Angenommen 7 Tage Intervall
            sunlight: ["Low light"],
            cycle: "Perennial",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/2786_abies_alba_pyramidalis/thumbnail/4929768_df55553_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/882_abies_alba_pyramidalis/medium/4925576768_f55596553_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/small/492557668_df55596553_b.jpg"
            ),
            indoor: true,
            cuisine: false,
            poisonousToHumans: true,
            poisonousToPets: true,
            description: "Elegant houseplant with white flowers.",
            soil: ["Well-drained"],
            origin: ["Tropical Americas"],
            pruningMonth: nil,
            invasive: false,
            careLevel: "Medium",
            fruits: false,
            edibleFruit: false,
            harvestSeason: nil,
            leaf: true,
            edibleLeaf: false,
            attracts: [],
            hardiness: Hardiness(min: "11", max: "12"),
            // lastWaterDate ist vor 8 Tagen, nextWaterDate war vor 1 Tag (da Intervall 7 Tage)
            waterings: [WateringRecord(date: calendar.date(byAdding: .day, value: -8, to: today)!)]
        )
        plant1.userCategory = .indoor // Beispielkategorie

        // --- Pflanze 2: Water Today (heute fällig) ---
        var plant2 = FirePlant(
            id: "fp_dummy_2",
            apiPlantId: 102,
            commonName: "Snake Plant",
            scientificName: ["Sansevieria trifasciata"],
            family: "Asparagaceae",
            genus: "Sansevieria",
            type: "Houseplant",
            dimensions: [DimensionItem(minValue: 0.6, maxValue: 1.2, unit: "meter")],
            watering: Watering(rawValue: "Minimum"), // Angenommen 14 Tage Intervall
            sunlight: ["Bright indirect light"],
            cycle: "Perennial",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/2786_abies_alba_pyramidalis/thumbnail/4929768_df55553_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/882_abies_alba_pyramidalis/medium/4925576768_f55596553_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/small/492557668_df55596553_b.jpg"
            ),
            indoor: true,
            cuisine: false,
            poisonousToHumans: true,
            poisonousToPets: true,
            description: "Hardy, air-purifying plant.",
            soil: ["Well-drained"],
            origin: ["West Africa"],
            pruningMonth: nil,
            invasive: false,
            careLevel: "Easy",
            fruits: false,
            edibleFruit: false,
            harvestSeason: nil,
            leaf: true,
            edibleLeaf: false,
            attracts: [],
            hardiness: Hardiness(min: "10", max: "12"),
            // lastWaterDate ist vor 14 Tagen, nextWaterDate ist heute
            waterings: [WateringRecord(date: calendar.date(byAdding: .day, value: -14, to: today)!)]
        )
        plant2.userCategory = .indoor

        // --- Pflanze 3: Water Tomorrow ---
        var plant3 = FirePlant(
            id: "fp_dummy_3",
            apiPlantId: 103,
            commonName: "ZZ Plant",
            scientificName: ["Zamioculcas zamiifolia"],
            family: "Araceae",
            genus: "Zamioculcas",
            type: "Houseplant",
            dimensions: [DimensionItem(minValue: 0.6, maxValue: 1.0, unit: "meter")],
            watering: Watering(rawValue: "Minimum"), // Angenommen 14 Tage Intervall
            sunlight: ["Low light"],
            cycle: "Perennial",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/2786_abies_alba_pyramidalis/thumbnail/4929768_df55553_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/882_abies_alba_pyramidalis/medium/4925576768_f55596553_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/small/492557668_df55596553_b.jpg"
            ),
            indoor: true,
            cuisine: false,
            poisonousToHumans: true,
            poisonousToPets: true,
            description: "Extremely drought-tolerant plant.",
            soil: ["Well-drained"],
            origin: ["East Africa"],
            pruningMonth: nil,
            invasive: false,
            careLevel: "Easy",
            fruits: false,
            edibleFruit: false,
            harvestSeason: nil,
            leaf: true,
            edibleLeaf: false,
            attracts: [],
            hardiness: Hardiness(min: "9", max: "11"),
            // lastWaterDate ist vor 13 Tagen, nextWaterDate ist morgen
            waterings: [WateringRecord(date: calendar.date(byAdding: .day, value: -13, to: today)!)]
        )
        plant3.userCategory = .indoor

        // --- Pflanze 4: Water in 5 days ---
        var plant4 = FirePlant(
            id: "fp_dummy_4",
            apiPlantId: 104,
            commonName: "Monstera Deliciosa",
            scientificName: ["Monstera deliciosa"],
            family: "Araceae",
            genus: "Monstera",
            type: "Houseplant",
            dimensions: [DimensionItem(minValue: 1.0, maxValue: 3.0, unit: "meter")],
            watering: Watering(rawValue: "Average"), // Angenommen 7 Tage Intervall
            sunlight: ["Bright indirect light"],
            cycle: "Perennial",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/2786_abies_alba_pyramidalis/thumbnail/4929768_df55553_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/882_abies_alba_pyramidalis/medium/4925576768_f55596553_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/small/492557668_df55596553_b.jpg"
            ),
            indoor: true,
            cuisine: false,
            poisonousToHumans: true,
            poisonousToPets: true,
            description: "Popular houseplant with unique fenestrated leaves.",
            soil: ["Well-drained"],
            origin: ["Southern Mexico"],
            pruningMonth: nil,
            invasive: false,
            careLevel: "Medium",
            fruits: false,
            edibleFruit: false,
            harvestSeason: nil,
            leaf: true,
            edibleLeaf: false,
            attracts: [],
            hardiness: Hardiness(min: "10", max: "12"),
            // lastWaterDate ist vor 2 Tagen, nextWaterDate ist in 5 Tagen
            waterings: [WateringRecord(date: calendar.date(byAdding: .day, value: -2, to: today)!)]
        )
        plant4.userCategory = .indoor

        // --- Pflanze 5: No watering info (missing lastWaterDate/nextWaterDate) ---
        var plant5 = FirePlant(
            id: "fp_dummy_5",
            apiPlantId: 105,
            commonName: "Cactus",
            scientificName: ["Cactaceae"],
            family: "Cactaceae",
            genus: "Various",
            type: "Succulent",
            dimensions: [DimensionItem(minValue: 0.1, maxValue: 2.0, unit: "meter")],
            watering: Watering(rawValue: "None"), // Angenommen 30 Tage Intervall
            sunlight: ["Full sun"],
            cycle: "Perennial",
            defaultImage: PlantImages(
                originalUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                regularUrl: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/og/49255768_df596553_b.jpg",
                mediumUrl: "https://perenual.com/storage/species_image/2786_abies_alba_pyramidalis/thumbnail/4929768_df55553_b.jpg",
                smallUrl: "https://perenual.com/storage/species_image/882_abies_alba_pyramidalis/medium/4925576768_f55596553_b.jpg",
                thumbnail: "https://perenual.com/storage/species_image/2678_abies_alba_pyramidalis/small/492557668_df55596553_b.jpg"
            ),
            indoor: false,
            cuisine: false,
            poisonousToHumans: false,
            poisonousToPets: false,
            description: "Desert plant known for spines.",
            soil: ["Sandy"],
            origin: ["Americas"],
            pruningMonth: nil,
            invasive: false,
            careLevel: "Easy",
            fruits: false,
            edibleFruit: false,
            harvestSeason: nil,
            leaf: false,
            edibleLeaf: false,
            attracts: [],
            hardiness: Hardiness(min: "9", max: "11"),
            waterings: [] // Keine Bewässerungsdaten vorhanden
        )
        plant5.userCategory = .outdoor

        return [plant1, plant2, plant3, plant4, plant5]
    }()
}



