//
//  WeatherModel.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/14/24.
//

import Foundation
// MARK: - WeatherModel
struct WeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: String?
    let sunrise, sunset: Int?
    let cod: Int?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}

let jsonData = Data("""
{
    "coord": { "lon": -0.1257, "lat": 51.5085 },
    "weather": [
        { "id": 800, "main": "Clear", "description": "clear sky", "icon": "01d" }
    ],
    "base": "stations",
    "main": {
        "temp": 282.55,
        "feels_like": 281.86,
        "temp_min": 280.37,
        "temp_max": 284.26,
        "pressure": 1023,
        "humidity": 100,
        "sea_level": 1023,

        "grnd_level": 1023
    },
    "visibility": 10000,
    "wind": { "speed": 4.1, "deg": 80 },
    "clouds": { "all": 1 },
    "dt": 1485789600,
    "sys": {
        "type": 1,
        "id": 5091,
        "country": "GB",
        "sunrise": 1485762037,
        "sunset": 1485794875
    },
    "timezone": 0,
    "id": 2643743,
    "name": "London",
    "cod": 200
}
""".utf8)

func tempWeatherModel() -> WeatherModel {
    do {
        let json = try JSONDecoder().decode(WeatherModel.self, from: jsonData)
        return json
    } catch {
        print(error)
    }
    return WeatherModel.init(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, clouds: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: nil, cod: nil)
}
