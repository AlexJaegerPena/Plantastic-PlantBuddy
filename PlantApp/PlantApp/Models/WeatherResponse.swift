//
//  WeatherResponse.swift
//  PlantApp
//
//  Created by Alexandra Jäger on 26.05.25.
//

import Foundation


struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
    let forecast: WeatherForecast?
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let localtime: String
}

struct CurrentWeather: Codable {
    let tempC: Double
    let condition: WeatherCondition
    let humidity: Int
    let precipMm: Double
    let cloud: Int
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case humidity
        case precipMm = "precip_mm"
        case cloud
    }
}

struct WeatherForecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: DailyTemperatures
}

struct DailyTemperatures: Codable {
    let avgTempC: Double
    let totalPrecipMm: Double
    let dailyWillItRain: Int
    let dailyChanceOfRain: Int
    let condition: WeatherCondition
    
    enum CodingKeys: String, CodingKey {
        case avgTempC = "avgtemp_c"
        case totalPrecipMm = "totalprecip_mm"
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case condition
    }
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
    let code: Int
}


enum WeatherCategory {
    case sunny
    case partlyCloudy
    case cloudy
    case mist
    case rainLight
    case rainHeavy
    case snow
    case sleet
    case thunder
    case unknown
    
    var systemImageName: String {
        switch self {
        case .sunny: return "sun.max.fill"
        case .partlyCloudy: return "cloud.sun.fill"
        case .cloudy: return "cloud.fill"
        case .mist: return "cloud.fog.fill"
        case .rainLight: return "cloud.drizzle.fill"
        case .rainHeavy: return "cloud.rain.fill"
        case .snow: return "snowflake"
        case .sleet: return "cloud.sleet.fill"
        case .thunder: return "cloud.bolt.rain.fill"
        case .unknown: return "cloud.sun.fill"
        }
    }
  
    var backgroundImageName: String {
        switch self {
        case .sunny: return "sunny2"
        case .partlyCloudy: return "clear2"
        case .cloudy: return "clear2"
        case .mist: return "mist2"
        case .rainLight: return "mist2"
        case .rainHeavy: return "rain2"
        case .snow: return "snow2"
        case .sleet: return "snow2"
        case .thunder: return "rainHeavy2"
        case .unknown: return "clear2"
        }
    }
}

extension WeatherCategory {
    static func from(code: Int) -> WeatherCategory {
        switch code {
        case 1000:
            return .sunny
        case 1003:
            return .partlyCloudy
        case 1006, 1009:
            return .cloudy
        case 1030, 1135, 1147:
            return .mist
        case 1150, 1153, 1168, 1180, 1183, 1240, 1198:
            return .rainLight
        case 1186, 1189, 1192, 1195, 1243, 1246:
            return .rainHeavy
        case 1066, 1210, 1213, 1216, 1219, 1222, 1225, 1255, 1258, 1114, 1117:
            return .snow
        case 1069, 1072, 1204, 1207, 1249, 1252, 1237, 1261, 1264:
            return .sleet
        case 1087, 1273, 1276, 1279, 1282:
            return .thunder
        default:
            return .unknown
        }
    }
}
