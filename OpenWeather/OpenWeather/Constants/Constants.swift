//
//  Constants.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/14/24.
//

import Foundation

struct Constants {
    fileprivate static var apiKey = "f58587d8d1283825351c578ad580b679"
    
    func getCityAPI(city: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Constants.apiKey)"
    }
    
    func getCityCountryApi(city: String, countryCode: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?q=\(city),\(countryCode)&appid=\(Constants.apiKey)"
    }
    
    func getCityStateCountryApi(cityName: String, stateCode: String, countryCode: String) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?q=\(cityName),\(stateCode),\(countryCode)&appid=\(Constants.apiKey)"
    }
    static let iconApi = "http://openweathermap.org/weather-conditions"
}
