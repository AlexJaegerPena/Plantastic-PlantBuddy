//
//  WeatherView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct WeatherView: View {

    @ObservedObject var weatherViewModel: WeatherViewModel

    //    let weather: WeatherResponse

    var body: some View {

        ZStack {
            if let weather = weatherViewModel.weatherResponse {
                Image(
                    weatherViewModel.backgroundImageName(
                        for: weather.current.condition.code)
                )
                .resizable()
                .scaledToFill()
                .padding()
                .frame(width: .infinity, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: 120)
            }

            if let weather = weatherViewModel.weatherResponse {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Image(
                                    systemName:
                                        weatherViewModel.systemImageName(
                                            for: weather.current.condition.code)
                                )
                                .font(.system(size: 24))

                                Text(weather.current.condition.text)
                                    .font(.subheadline)
                            }

                            Text(
                                "\(weather.current.tempC, specifier: "%.1f")°C"
                            )
                            .font(.system(size: 40))
                            //                            .bold()
                            .padding(.leading, 10)

                            //                        Spacer()

                        }
                        .padding(.leading, 25)
                        .padding(.vertical, 20)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(
                                Date.now.formatted(
                                    date: .omitted, time: .shortened)
                            )
                            .font(.largeTitle)

                            Text(weather.location.name)
                        }
                        .padding(.trailing, 25)

                    }
                    .frame(width: .infinity, height: 105)
                    .background(.ultraThinMaterial.opacity(0.7))

                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .padding()
                }

                .frame(width: .infinity, height: 120)
                .foregroundStyle(.white)

            } else if weatherViewModel.isLoading {
                ProgressView("Weather is loading...")
                    .frame(width: .infinity, height: 120)
                    .foregroundStyle(.gray)
            } else if let error = weatherViewModel.errorMessage {
                Text("Fehler. \(error)")
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 20).fill(
                            Color.white.opacity(0.8)))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)  // Sicherstellen, dass die ZStack die Höhe hält
        .onAppear {
            // Beim Erscheinen der View versuchen, Wetterdaten zu laden (initial oder aktualisieren)
            // Das ViewModel tut dies bereits in init, aber ein manueller Aufruf ist hier auch gut,
            // falls die View mehrfach eingeblendet wird.
            // Task { await weatherViewModel.fetchWeatherForCurrentLocation() }
        }
    }
}

#Preview {
    //    let mockWeather = WeatherResponse(
    //        location: Location(name: "Barcelona", region: "Barcelona", country: "Spain", localtime: "2025-05-07 14:00"),
    //        current: CurrentWeather(
    //            tempC: 21.5,
    //            condition: WeatherCondition(text: "Partly Cloudy", icon: "partly-cloudy", code: 1003),
    //            humidity: 55,
    //            precipMm: 0.2,
    //            cloud: 40
    //        )
    //    )

    WeatherView(weatherViewModel: WeatherViewModel())
}
