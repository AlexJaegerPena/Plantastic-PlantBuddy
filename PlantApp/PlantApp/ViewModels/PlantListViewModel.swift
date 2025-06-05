//
//  PlantListViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation // Foundation ist für Task und DispatchQeueue erforderlich

@MainActor // Stellt sicher, dass Änderungen an @Published Properties auf dem Main Thread erfolgen
class PlantListViewModel: ObservableObject {

    @Published var plants: [Plant] = []
    @Published var searchTerm: String = ""
    @Published var plantSuggestionList: [Plant] = []

    @Published var isLoadingList: Bool = false
    @Published var listErrorMessage: String?

    // Private Task-Variable für die Debounce-Logik
    private var searchTask: Task<Void, Error>?

    private let plantRepository: PlantRepository

    init(plantRepository: PlantRepository) {
        self.plantRepository = plantRepository
    }

    // Funktion zum Abrufen der initialen Pflanzenliste
    func apiPlantsList() {
        // isLoadingList = true // Aktivieren, wenn du Ladeindikatoren verwenden möchtest
        listErrorMessage = nil // Fehlermeldung zurücksetzen

        Task {
            // defer { isLoadingList = false } // Sicherstellen, dass isLoadingList zurückgesetzt wird

            do {
                let response = try await plantRepository.fetchPlantsList()
                // DispatchQueue.main.async ist hier dank @MainActor nicht strikt notwendig,
                // aber schadet nicht und sorgt für explizite Thread-Sicherheit.
                self.plants = Array(response.prefix(40)) // Begrenzung auf 40 Pflanzen
                print("DEBUG: Successfully loaded \(self.plants.count) plants.")
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
                print("------------------------------------------")
            }
        }
    }

    // Funktion für die Suche nach Pflanzvorschlägen (Autovervollständigung)
    // DIES IST EINE FUNKTION UND DARF KEIN @Published SEIN!
    func plantSuggestions(for query: String) {
        guard !query.isEmpty else {
            // Wenn der Suchbegriff leer ist, lösche die Vorschläge
            self.plantSuggestionList = []
            return
        }

        // Debounce-Logik (optional, aber empfohlen für Sucheingaben)
        // Bricht vorherige Suchanfrage ab und startet eine neue nach kurzer Verzögerung
        self.searchTask?.cancel() // Vorherige Task abbrechen
        self.searchTask = Task { // Neue Task starten
            do {
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 Sekunden Verzögerung
                try Task.checkCancellation() // Prüfen, ob die Task abgebrochen wurde

                let fetchedSuggestions = try await plantRepository.fetchPlantsByQuery(query)
                // Aktualisiere die @Published plantSuggestionList auf dem MainActor
                self.plantSuggestionList = fetchedSuggestions

            } catch is CancellationError {
                print("DEBUG: Search suggestion task was cancelled.")
            } catch {
                // Allgemeine Fehlerbehandlung für Vorschläge
                self.listErrorMessage = "Fehler beim Laden der Vorschläge: \(error.localizedDescription)"
                print("--- ERROR IN VIEWMODEL (plantSuggestions) ---")
                print("Localized Description: \(error.localizedDescription)")
                print("Full Error Object: \(error)")
                // Detaillierte Fehlerprüfung wie oben hinzufügen, falls nötig
                print("------------------------------------------")
            }
            self.searchTask = nil // Task nach Abschluss zurücksetzen
        }
    }

    // Funktion für die finale Suche (z.B. nach Button-Klick)
    func searchPlantByName(for name: String) {
        // isLoadingList = true // Aktivieren, wenn du Ladeindikatoren verwenden möchtest
        listErrorMessage = nil // Fehlermeldung zurücksetzen

        Task {
            // defer { isLoadingList = false } // Sicherstellen, dass isLoadingList zurückgesetzt wird

            do {
                let results = try await plantRepository.fetchPlantsByQuery(name)
                // Aktualisiere die Haupt-Pflanzenliste mit den Suchergebnissen
                self.plants = results
                print("DEBUG: Search results loaded: \(self.plants.count) plants for '\(name)'.")
            } catch {
                // Fehlerbehandlung
                self.listErrorMessage = "Fehler bei der Suche: \(error.localizedDescription)"
                print("--- ERROR IN VIEWMODEL (searchPlantByName) ---")
                print("Localized Description: \(error.localizedDescription)")
                print("Full Error Object: \(error)")
                // Detaillierte Fehlerprüfung wie oben hinzufügen, falls nötig
                print("------------------------------------------")
            }
        }
    }
}
