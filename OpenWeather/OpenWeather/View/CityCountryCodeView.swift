//
//  CityCountryCodeView.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/14/24.
//

import SwiftUI

struct CityCountryCodeView: View {
    /// Stores the city name entered by the user.
    @State private var city: String = ""
    
    /// Stores the country code entered by the user.
    @State private var countryCode: String = ""
    
    /// The view model responsible for fetching and managing weather data.
    /// Marked as `@StateObject` to ensure the view model's lifecycle is managed by the view.
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    /// A flag to indicate whether the user has left the city or country code fields empty.
    @State private var dataEnteredEmpty = false
    
    /// Tracks the number of times the user retries fetching data after an error.
    @State private var retryCount = 0
    
    /// A flag to indicate whether the retry limit (3 retries) has been reached, triggering a specific alert.
    @State private var showRetryLimitReachedAlert = false

    var body: some View {
        /// The main navigation structure that allows for deep navigation hierarchies.
            NavigationStack {
                VStack(spacing: 20) {
                    /// A text field for the user to enter the city name.
                    TextField("City", text: $city)
                        .textFieldStyle(.roundedBorder) // Rounded border style for the text field.
                        .padding() // Adds padding around the text field.

                    /// A text field for the user to enter the country code.
                    TextField("Country Code", text: $countryCode)
                        .textFieldStyle(.roundedBorder) // Rounded border style for the text field.
                        .padding() // Adds padding around the text field.

                    /// A submit button that triggers the weather data fetch when pressed.
                    Button("Submit") {
                        Task {
                            if city.isEmpty || countryCode.isEmpty {
                                self.dataEnteredEmpty = true // Show an alert if either field is empty.
                            } else {
                                await
                                weatherViewModel.getData(city: city, countryCode: countryCode, whichApiCalled: .cityAndCountry)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent) // Prominent style for the button.
                    .padding() // Adds padding around the button.

                    /// Displays the weather information if it is successfully fetched and available.
                    if let weatherModel = weatherViewModel.weatherModel {
                        WeatherDetailsView(weatherModel: weatherModel)
                            .padding()
                    }
                }
                .padding() // Adds padding around the entire VStack.
                .navigationTitle("Search by City and Country Code") // Sets the navigation title.
                .navigationBarTitleDisplayMode(.inline) // Displays the title inline.
                .padding() // Adds extra padding around the content.
                
                /// Handles an error during the API call by displaying an alert.
                .alert("Error fetching data. Try again later.", isPresented: $weatherViewModel.hasCallAPiError) {
                    Button("Retry", role: .cancel) {
                        retryCount += 1
                        if retryCount > 3 {
                            showRetryLimitReachedAlert = true // Triggers a separate alert if the retry limit is reached.
                        }
                        Task {
                            await
                            weatherViewModel.getData(city: city, countryCode: countryCode, whichApiCalled: .cityAndCountry)
                        }
                    }
                    Button("Ok", role: .cancel) {
                        weatherViewModel.hasCallAPiError = true // Dismisses the error alert.
                    }
                }
                
                /// Displays an alert if the user submits without entering data.
                .alert("Enter data to see weather.", isPresented: $dataEnteredEmpty) {
                }
                
                /// Displays an alert if the retry limit is reached.
                .alert("Try again later. Our servers are down.", isPresented: $showRetryLimitReachedAlert) {
                    Button("Ok", role: .cancel) {
                        retryCount = 0 // Resets the retry count.
                    }
                }
            }
    }
}

#Preview {
    CityCountryCodeView()
}
