//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/14/24.
//

import Foundation
import Combine

/// `WeatherViewModel` is responsible for managing weather data fetched from an API and providing that data to the view.
/// It handles the business logic, processes API responses, and updates the view accordingly.
class WeatherViewModel: ObservableObject {
    /// A set of AnyCancellable to hold Combine's cancellable objects, ensuring the Combine subscriptions are properly managed.
    private var cancellables = Set<AnyCancellable>()
    
    /// The weather model that stores the weather data fetched from the API.
    /// Marked as `@Published` so that any changes automatically update the view.
    @Published var weatherModel: WeatherModel?
    
    /// A flag that indicates whether there was an error during the API call.
    /// Marked as `@Published` to notify the view to display an error message when necessary.
    @Published var hasCallAPiError = false
    
    /// A dictionary to store the processed weather data, such as city name, coordinates, temperature, etc.
    /// Marked as `@Published` to update the view when new data is processed.
    @Published var result = [String: String]()
    
    /// Tracks which API was called (e.g., by city only, by city and country, or by city, state, and country).
    private var whichApiCalled: WhichApiCalled = .cityOnly
    
    /// Retrieves the city name from the weather model.
    /// - Returns: The city name or "No Name" if the city name is not available.
    func getCityName() -> String {
       return weatherModel?.name ?? "No Name"
    }

    /// Converts the coordinates into a readable string format.
    /// - Parameter coord: The coordinates structure containing latitude and longitude.
    /// - Returns: A string describing the latitude and longitude or "N/A" if not available.
    func getCoord(coord: Coord) -> String {
        if let lat = coord.lat, let lon = coord.lon {
            return "Latitude: \(String(describing: lat)) Longitude: \(String(describing: lon))"
        }
        return "N/A"
    }
    
    /// Processes the weather data and updates the view model's properties asynchronously.
    /// - Parameter model: The weather model containing the data fetched from the API.
    func getCityDataFromModel(_ model: WeatherModel) async {
        DispatchQueue.main.async { [weak self] in
            self?.weatherModel = model
            if let weatherData = self?.weatherModel, let coord = weatherData.coord, let weather = weatherData.weather?.first, let main = weatherData.main {
                self?.result["City:"] = weatherData.name ?? "N/A"
                self?.result["Coordinates:"] = "(\(coord.lon ?? 0.0), \(coord.lat ?? 0.0))"
                self?.result["Description:"] = weather.description ?? "N/A"
                self?.result["Temperature:"] = "\(main.temp ?? 0.0)°C"
                self?.result["Feels Like:"] = "\(String(describing: main.feelsLike))°C"
            }
        }
    }
    
    /// Fetches weather data based on the city, state code, and country code, using different APIs depending on the input.
    /// - Parameters:
    ///   - city: The name of the city for which to fetch weather data.
    ///   - stateCode: The state code (optional).
    ///   - countryCode: The country code (optional).
    ///   - whichApiCalled: Specifies which API to call (e.g., city-only, city and country, or city, state, and country).
    func getData(city: String, stateCode: String? = nil, countryCode: String? = nil, whichApiCalled: WhichApiCalled) async {
        var tempUrl: URL?
        
        /// Determines which API URL to use based on the provided parameters.
        switch whichApiCalled {
        case .cityOnly:
            tempUrl = URL(string: Constants().getCityAPI(city: city))
        case .cityAndCountry:
            if let countryCode = countryCode {
                tempUrl = URL(string: Constants().getCityCountryApi(city: city, countryCode: countryCode))
            }
        case .cityStateAndCountry:
            if let countryCode = countryCode, let stateCode = stateCode {
                tempUrl = URL(string: Constants().getCityStateCountryApi(cityName: city, stateCode: stateCode, countryCode: countryCode))
            }
        }
        
        /// Ensures the URL is valid before proceeding with the API call.
        guard let url = tempUrl else {
            print("Invalid URL: \(String(describing: tempUrl))")
            return
        }
        
        /// Initiates the API call using Combine's `dataTaskPublisher`.
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main) // Receives the data on the main thread.
            .map(\.data) // Extracts the data from the URL session response.
            .decode(type: WeatherModel.self, decoder: JSONDecoder()) // Decodes the data into a `WeatherModel`.
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(_):
                    self.weatherModel = nil
                    self.hasCallAPiError = true // Sets the error flag if the API call fails.
                }
            }, receiveValue: { model in
                self.weatherModel = model // Updates the weather model with the fetched data.
            })
            .store(in: &cancellables) // Stores the subscription to manage its lifecycle.
    }
}

/// `WhichApiCalled` is an enum that tracks which API was called to fetch weather data.
/// It has three cases:
/// - `cityOnly`: Fetches data using only the city name.
/// - `cityAndCountry`: Fetches data using the city name and country code.
/// - `cityStateAndCountry`: Fetches data using the city name, state code, and country code.
enum WhichApiCalled {
    case cityOnly
    case cityAndCountry
    case cityStateAndCountry
}
