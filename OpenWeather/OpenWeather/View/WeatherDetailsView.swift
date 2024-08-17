//
//  ResultView.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/15/24.
//

import SwiftUI

struct WeatherDetailsView: View {
    /// The weather model containing the data to be displayed.
    let weatherModel: WeatherModel?
    
    /// The view model responsible for managing additional weather-related logic.
    /// Marked as `@StateObject` to ensure the view model's lifecycle is managed by the view.
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some View {
        /// Checks if the `weatherModel` is available before displaying the details.
        if let weatherModel = weatherModel {
            List {
                /// Section to display the location details such as city name and coordinates.
                Section("Location") {
                    /// Displays the city name if available.
                    if let name = weatherModel.name {
                        HStack {
                            Text("City:") // Label for the city name.
                                .bold() // Makes the label text bold.
                            Text(name) // Displays the city name.
                        }
                    }
                    
                    /// Displays the coordinates if available.
                    if let coord = weatherModel.coord {
                        HStack {
                            Text("Coordinates:") // Label for the coordinates.
                                .bold() // Makes the label text bold.
                            Text(weatherViewModel.getCoord(coord: coord)) // Converts the coordinates to a readable format.
                        }
                    }
                }
                
                /// Section to display weather conditions such as the "feels like" temperature.
                Section("Conditions") {
                    /// Displays the "feels like" temperature if available.
                    if let feelsLike = weatherModel.main?.feelsLike {
                        HStack {
                            Text("Feels Like:") // Label for the "feels like" temperature.
                                .bold() // Makes the label text bold.
                            Text("\(feelsLike)") // Displays the "feels like" temperature.
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    WeatherDetailsView(weatherModel: nil)
}
