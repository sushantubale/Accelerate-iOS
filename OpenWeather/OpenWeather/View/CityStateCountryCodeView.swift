//
//  CityStateCountryCodeView.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/14/24.
//

import SwiftUI

struct CityStateCountryCodeView: View {
    /// Stores the city name entered by the user.
    @State private var city: String = ""
    
    /// Stores the state code entered by the user.
    @State private var stateCode: String = ""
    
    /// Stores the country code entered by the user.
    @State private var countryCode: String = ""
    
    /// The view model responsible for fetching and managing weather data.
    /// Marked as `@StateObject` to ensure the view model's lifecycle is managed by the view.
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    /// A flag to indicate whether the user has left any of the required fields (city, state, or country code) empty.
    @State private var dataEnteredEmpty = false
    
    var body: some View {
        /// The main navigation structure that allows for deep navigation hierarchies.
        NavigationStack {
            VStack(spacing: 20) {
                /// A text field for the user to enter the city name.
                TextField("City", text: $city)
                    .textFieldStyle(.roundedBorder) // Rounded border style for the text field.
                
                /// A text field for the user to enter the state code.
                TextField("State", text: $stateCode)
                    .textFieldStyle(.roundedBorder) // Rounded border style for the text field.
                
                /// A text field for the user to enter the country code.
                TextField("Country Code", text: $countryCode)
                    .textFieldStyle(.roundedBorder) // Rounded border style for the text field.

                /// A submit button that triggers the weather data fetch when pressed.
                Button("Submit") {
                    Task {
                        /// Checks if any of the required fields are empty and sets the flag to show an alert if necessary.
                        if city.isEmpty || countryCode.isEmpty || stateCode.isEmpty {
                            self.dataEnteredEmpty = true
                        } else {
                            /// Fetches weather data based on the provided city, state, and country code.
                            await weatherViewModel.getData(city: city, stateCode: stateCode, countryCode: countryCode, whichApiCalled: .cityStateAndCountry)
                        }
                    }
                }
                .buttonStyle(PressButton()) // Applies a custom button style.
                
                /// Displays the weather information if it is successfully fetched and available.
                if let weatherModel = weatherViewModel.weatherModel {
                    WeatherDetailsView(weatherModel: weatherModel)
                        .padding()
                }
                Spacer() // Pushes content to the top, leaving space at the bottom.
            }
            .navigationTitle("Search by City, State & Country Code") // Sets the navigation title.
            .navigationBarTitleDisplayMode(.inline) // Displays the title inline.
            .padding() // Adds padding around the entire VStack.
            
            /// Handles an error during the API call by displaying an alert.
            .alert("Error message", isPresented: $weatherViewModel.hasCallAPiError) {
                Button("Retry", role: .cancel) {
                    Task {
                        /// Retries fetching weather data if the API call fails.
                        await
                        weatherViewModel.getData(city: city, countryCode: countryCode, whichApiCalled: .cityAndCountry)
                    }
                }
                Button("Ok", role: .cancel) {
                    weatherViewModel.hasCallAPiError = true // Dismisses the error alert.
                }
            }
            
            /// Displays an alert if the user submits without entering all the required data.
            .alert("Enter all data and try again", isPresented: $dataEnteredEmpty) {
            }
        }
    }
}

#Preview {
    CityStateCountryCodeView()
}
