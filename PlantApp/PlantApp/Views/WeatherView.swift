//
//  WeatherView.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import SwiftUI

struct WeatherView: View {

    @ObservedObject var weatherViewModel: WeatherViewModel

    var body: some View {

        ZStack {
            if let weather = weatherViewModel.weatherResponse {
                Image(
                    weatherViewModel.backgroundImageName(
                        for: weather.current.condition.code)
                )
                .resizable()
                .scaledToFill()
                .frame(height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 35))
            } else {
                RoundedRectangle(cornerRadius: 35)
                    .fill(Color.gray.opacity(0.3))
                    .frame(maxWidth: .infinity, maxHeight: 80)
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
                            .padding(.leading, 5)

                            Text(
                                "\(weather.current.tempC, specifier: "%.1f")°C"
                            )
                            .font(.system(size: 35))
                            .padding(.leading, 10)
                        }
                        .padding(.leading, 25)
                        .padding(.vertical, 20)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(weather.location.name)
                                .font(.system(size: 25))
                        }
                        .padding(.trailing, 35)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .background(.ultraThinMaterial.opacity(0.7))
                    .cornerRadius(35)
                }
                .foregroundStyle(Color.white)

            } else if weatherViewModel.isLoading {
                ProgressView("Weather is loading...")
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .foregroundStyle(.gray)
                    .padding()
                
            } else if let error = weatherViewModel.errorMessage {
                Text("Fehler. \(error)")
                    .foregroundColor(.red)
                    .padding()
                    .frame(width: .infinity, height: 80)
                    .background(
                        RoundedRectangle(cornerRadius: 35).fill(
                            Color.white.opacity(0.8)))
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .onAppear {
            Task { await weatherViewModel.fetchWeatherForCurrentLocation() }
        }
    }
}

#Preview {
    WeatherView(weatherViewModel: WeatherViewModel())
}
