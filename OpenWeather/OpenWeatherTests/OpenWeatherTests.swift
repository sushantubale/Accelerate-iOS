//
//  OpenWeatherTests.swift
//  OpenWeatherTests
//
//  Created by Sushant Ubale on 8/13/24.
//

import XCTest
@testable import OpenWeather

final class OpenWeatherTests: XCTestCase {
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
    
       func testDecodeWeatherModel_WithCompleteData() throws {
           let decoder = JSONDecoder()
           let weatherModel = try decoder.decode(WeatherModel.self, from: jsonData)
           XCTAssertEqual(weatherModel.coord?.lon, -0.1257)
           XCTAssertEqual(weatherModel.coord?.lat, 51.5085)
           XCTAssertEqual(weatherModel.weather?.first?.description, "clear sky")
           XCTAssertEqual(weatherModel.main?.temp, 282.55)
       }

    func testGetName() {
        let viewModel = WeatherViewModel()
        let cityName = viewModel.getCityName()
        let decoder = JSONDecoder()
        do {
            let weatherModel = try decoder.decode(WeatherModel.self, from: jsonData)
            viewModel.weatherModel = weatherModel
        } catch {
            print(error)
        }
        XCTAssertEqual("London", cityName)
    }
    
    func testGetCoord() {
        let viewModel = WeatherViewModel()
        let decoder = JSONDecoder()
        do {
            let weatherModel = try decoder.decode(WeatherModel.self, from: jsonData)
            viewModel.weatherModel = weatherModel
            if let tempCoord = weatherModel.coord {
                let coord = viewModel.getCoord(coord: tempCoord)
                print(coord)
                XCTAssertEqual("Latitude: 51.5085 Longitude: -0.1257", coord)
            }
        } catch {
            print(error)
        }
    }
}
