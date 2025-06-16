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

//        ZStack {
//            if let weather = weatherViewModel.weatherResponse {
//                Image(
//                    weatherViewModel.backgroundImageName(
//                        for: weather.current.condition.code)
//                )
//                .resizable()
//                .scaledToFill()
//                .padding()
//                .frame(maxWidth: .infinity, maxHeight: 120)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//
//            } else {
//                RoundedRectangle(cornerRadius: 20)
//                    .fill(Color.gray.opacity(0.3))
//                    .frame(maxWidth: .infinity, maxHeight: 120)
//            }
//
//            if let weather = weatherViewModel.weatherResponse {
//                VStack(alignment: .leading) {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            HStack {
//                                Image(
//                                    systemName:
//                                        weatherViewModel.systemImageName(
//                                            for: weather.current.condition.code)
//                                )
//                                .font(.system(size: 24))
//
//                                Text(weather.current.condition.text)
//                                    .font(.subheadline)
//                            }
//
//                            Text(
//                                "\(weather.current.tempC, specifier: "%.1f")°C"
//                            )
//                            .font(.system(size: 40))
//                            .padding(.leading, 10)
//
//                        }
//                        .padding(.leading, 25)
//                        .padding(.vertical, 20)
//                        
//                        Spacer()
//                        
//                        VStack(alignment: .trailing) {
//                            Text(weather.location.name)
//                            HStack {
//                                Text("Test")
//                            }
//                           
//                        }
//                        .padding(.trailing, 25)
//
//                    }
//                    .frame(width: .infinity, height: 105)
//                    .background(.ultraThinMaterial.opacity(0.7))
//                    .cornerRadius(20)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
//                    )
//                    .padding()
//                }
//                .frame(maxWidth: .infinity, maxHeight: 120)
//                .foregroundStyle(.white)
//
//            } else if weatherViewModel.isLoading {
//                ProgressView("Weather is loading...")
//                    .frame(maxWidth: .infinity, maxHeight: 120)
//                    .foregroundStyle(.gray)
//                    .padding()
//                
//            } else if let error = weatherViewModel.errorMessage {
//                Text("Fehler. \(error)")
//                    .foregroundColor(.red)
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: 120)
//                    .background(
//                        RoundedRectangle(cornerRadius: 20).fill(
//                            Color.white.opacity(0.8)))
//            }
//        }
        
        ZStack {
            if let weather = weatherViewModel.weatherResponse {
                Image(
                    weatherViewModel.backgroundImageName(
                        for: weather.current.condition.code)
                )
                
                .resizable()
                .scaledToFill()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 120)
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
                            .padding(.leading, 10)

                        }
                        .padding(.leading, 25)
                        .padding(.vertical, 20)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(weather.location.name)
                            HStack {
//                                if let weatherForecast = weatherViewModel.weatherForecastResponse {
//                                    
//                                }
                            }
                        }
                        .padding(.trailing, 25)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 105)
                    .background(.ultraThinMaterial.opacity(0.7))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .padding()
                }
                .foregroundStyle(.white)

            } else if weatherViewModel.isLoading {
                ProgressView("Weather is loading...")
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .foregroundStyle(.gray)
                    .padding()
                
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
        
        .frame(maxWidth: .infinity, maxHeight: 120)
        .onAppear {
            Task { await weatherViewModel.fetchWeatherForCurrentLocation() }
//            Task { await weatherViewModel.fetchForecastWeather(for: "Cologne") }
        }
    }
}

#Preview {
    WeatherView(weatherViewModel: WeatherViewModel())
}
