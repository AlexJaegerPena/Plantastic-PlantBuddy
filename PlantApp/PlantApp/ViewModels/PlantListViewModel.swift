//
//  PlantListViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation

@MainActor
class PlantListViewModel: ObservableObject {

    @Published var plants: [Plant] = []
    @Published var searchTerm: String = ""
    @Published var plantSuggestionList: [Plant] = []
    @Published var listErrorMessage: String?
    

    // Private Task-Variable für die Debounce-Logik
    private var searchTask: Task<Void, Error>?

    private let plantRepository: PlantRepository = LocalPlantRepository()
    // private let plantRepository: PlantRepository = RemotePlantRepository()
    
    init() {
        apiPlantsList()
    }


    // Funktion zum Abrufen der initialen Pflanzenliste
    func apiPlantsList() {
        listErrorMessage = nil

        Task {
            do {
                let response = try await plantRepository.fetchPlantsList()
                self.plants = Array(response.prefix(40)) // Begrenzung auf 40 Pflanzen
                print("Successfully loaded \(self.plants.count) plants.")
            } catch {
                // Fehlerbehandlung auf dem Main Thread
                self.listErrorMessage = "Ein Fehler ist aufgetreten: \(error.localizedDescription)"
                print("--- ERROR IN VIEWMODEL (apiPlantsList) ---")
                print("Localized Description: \(error.localizedDescription)")
                print("Full Error Object: \(error)")

                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .dataCorrupted(let context):
                        print("Decoding Error: Data corrupted. Context: \(context.debugDescription), Coding Path: \(context.codingPath)")
                    case .keyNotFound(let key, let context):
                        print("Decoding Error: Key '\(key.stringValue)' not found. Context: \(context.debugDescription), Coding Path: \(context.codingPath)")
                    case .valueNotFound(let type, let context):
                        print("Decoding Error: Value of type \(type) not found. Context: \(context.debugDescription), Coding Path: \(context.codingPath)")
                    case .typeMismatch(let type, let context):
                        print("Decoding Error: Type mismatch for \(type). Context: \(context.debugDescription), Coding Path: \(context.codingPath)")
                    @unknown default:
                        print("Decoding Error: Unknown. \(decodingError)")
                    }
                }
            }
        }
    }


    func plantSuggestions(for query: String) {
        guard !query.isEmpty else {
            self.plantSuggestionList = []
            return
        }
        // Debounce-Logik
        // Bricht vorherige Suchanfrage ab und startet eine neue nach kurzer Verzögerung
        self.searchTask?.cancel() // Vorherige Task abbrechen
        self.searchTask = Task { // Neue Task starten
            do {
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 Sekunden Verzögerung
                try Task.checkCancellation() // Prüfen, ob die Task abgebrochen wurde

                let fetchedSuggestions = try await plantRepository.fetchPlantsByQuery(query)
                self.plantSuggestionList = fetchedSuggestions

            } catch is CancellationError {
                print("Search suggestion task was cancelled.")
            } catch {
                self.listErrorMessage = "Fehler beim Laden der Vorschläge: \(error.localizedDescription)"
                print("--- ERROR IN VIEWMODEL (plantSuggestions) ---")
                print("Localized Description: \(error.localizedDescription)")
                print("Full Error Object: \(error)")
            }
            self.searchTask = nil // Task nach Abschluss zurücksetzen
        }
    }

 
//    func searchPlantByName(for name: String) {
//        listErrorMessage = nil
//        Task {
//            do {
//                let results = try await plantRepository.fetchPlantsByQuery(name)
//                // Hauptpflanzenliste aktualisieren
//                self.plants = results
//                print("Search results loaded: \(self.plants.count) plants for '\(name)'.")
//            } catch {
//                self.listErrorMessage = "Fehler bei der Suche: \(error.localizedDescription)"
//                print("--- ERROR IN VIEWMODEL (searchPlantByName) ---")
//                print("Localized Description: \(error.localizedDescription)")
//                print("Full Error Object: \(error)")
//            }
//        }
//    }
}
