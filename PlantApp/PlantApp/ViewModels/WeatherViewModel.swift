//
//  WeatherViewModel.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 27.05.25.
//

import CoreLocation
import Foundation
import SwiftUI

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var weatherResponse: WeatherResponse?
    @Published var weatherForecastResponse: WeatherForecast?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let locationManager = CLLocationManager()
    private let weatherRepository = WeatherRepository()
    private var suggestionTask: Task<Void, Never>?

    @Published var currentCity: String {
        didSet {
            // Speichere die ausgewählte Stadt, wenn sie sich ändert
            UserDefaults.standard.set(currentCity, forKey: "lastSelectedCity")
            // Löse eine neue Wetterabfrage aus
            Task { await fetchWeather(for: currentCity) }
        }
    }

    override init() {
        _currentCity = Published(
            initialValue: UserDefaults.standard.string(
                forKey: "lastSelectedCity") ?? "Cologne")
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // Genaue Ortung
        // Dieser Aufruf fordert den Benutzer auf, die Berechtigung zu erteilen & löst einen System-Dialog aus.
        locationManager.requestWhenInUseAuthorization()
        // Fordert eine einmalige Standortaktualisierung an, sobald die Berechtigung erteilt wurde oder wenn sie bereits erteilt ist.
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()

        Task {
            await fetchWeatherForCurrentLocation()
            // Falls das fehlschlägt oder keine Berechtigung erteilt wurde, versuche die Standardstadt
            if weatherResponse == nil && errorMessage != nil {
                await fetchWeather(for: currentCity)
            }
        }
    }
    
    

    @MainActor
    func fetchWeatherForCurrentLocation() async {
        isLoading = true
        errorMessage = nil
        // Request Location ruft didUpdateLocations oder didFailWithError auf
        // und dort wird dann die API aufgerufen.
        locationManager.requestLocation()
    }
    
    // Holt Wetterdaten für eine spezifische Stadt
    @MainActor
    func fetchWeather(for city: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await weatherRepository.fetchCurrentWeather(
                for: city)
            self.weatherResponse = response
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
            self.weatherResponse = nil
            print(
                "Fehler beim Abrufen des Wetters für \(city): \(error.localizedDescription)"
            )
        }
        isLoading = false
    }
    
    @MainActor
    func fetchForecastWeather(for city: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let response = try await weatherRepository.fetchWeatherForecast(
                for: city)
            self.weatherForecastResponse = response
            self.errorMessage = nil
        } catch {
            self.weatherForecastResponse = nil
            self.errorMessage = error.localizedDescription
            print(
                "Fehler beim Abrufen des Wetters für \(city): \(error.localizedDescription)"
            )
        }
        isLoading = false
    }

    
    


    // Wird aufgerufen, wenn neue Standortdaten verfügbar sind
    internal func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else {
            Task { @MainActor in
                self.errorMessage = "Keine Standortdaten verfügbar."
                self.isLoading = false
            }
            return
        }

        let coordinates = location.coordinate
        Task { @MainActor in
            do {
                let response = try await weatherRepository.fetchCurrentWeather(
                    coordinates: coordinates)
                self.weatherResponse = response
                self.errorMessage = nil
            } catch {
                self.errorMessage = error.localizedDescription
                self.weatherResponse = nil
                print(
                    "Fehler beim Abrufen des Wetters für Koordinaten: \(error.localizedDescription)"
                )
            }
            self.isLoading = false
        }
    }

    // Wird aufgerufen, wenn die Standortbestimmung fehlschlägt
    internal func locationManager(
        _ manager: CLLocationManager, didFailWithError error: Error
    ) {
        // Ignoriere den Fehler, wenn keine Berechtigung erteilt wurde und versuche die Standardstadt zu laden
        if let clError = error as? CLError, clError.code == .denied {
            Task { @MainActor in
                print(
                    "Standortberechtigung verweigert. Versuche, Wetter für \(currentCity) zu laden."
                )
                await fetchWeather(for: currentCity)
            }
            return
        }

        Task { @MainActor in
            self.errorMessage =
                "Standort konnte nicht ermittelt werden: \(error.localizedDescription)"
            self.isLoading = false
            print("CLLocationManager Fehler: \(error.localizedDescription)")
        }
    }

    // Hilfsfunktion, die Current Weather und FOrecast bündelt
    private func _fetchWeatherData(for query: String?, coordinates: CLLocationCoordinate2D?) async {
        isLoading = true
        errorMessage = nil
        if query == nil {
            
        } else if coordinates == nil {
            
        } else {
            errorMessage = "Kein Standort für die Wetterabfrage verfügbar"
        }
        
        
        isLoading = false
    }

    func systemImageName(for code: Int) -> String {
        return WeatherCategory.from(code: code).systemImageName
    }

    func backgroundImageName(for code: Int) -> String {
        return WeatherCategory.from(code: code).backgroundImageName
    }
}
