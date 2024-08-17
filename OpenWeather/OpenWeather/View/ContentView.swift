//
//  ContentView.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/13/24.
//

import SwiftUI

struct ContentView: View {
    /// The city name entered by the user for which weather data is to be fetched.
    @State var searchCity = ""
    
    /// The view model responsible for handling weather data fetching and business logic.
    /// Marked as `@StateObject` to ensure the view model's lifecycle is managed by the view.
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    /// A boolean flag to indicate whether the app is currently loading data.
    @State private var isLoading = false

    var body: some View {
        /// The main content view embedded in a `NavigationView`.
        NavigationView {
            VStack(spacing: 20) {
                /// A placeholder view that enables the searchable functionality for the city search.
                EmptyView()
                    .searchable(text: $searchCity) // Binds the search text to `searchCity`.
                    .navigationTitle("Search by City") // Sets the navigation title.
                    .onSubmit(of: .search) {
                        /// Handles the search action when the user submits the search query.
                        Task {
                            isLoading = true // Shows the loading indicator.
                            await weatherViewModel.getData(city: searchCity, whichApiCalled: .cityOnly)
                            isLoading = false // Hides the loading indicator.
                        }
                    }
                    .alert("Error message", isPresented: $weatherViewModel.hasCallAPiError) {
                        /// Displays an alert if there's an error during the API call.
                        Button("Retry", role: .cancel) {
                            Task {
                                await weatherViewModel.getData(city: searchCity, whichApiCalled: .cityOnly) // Retries fetching data.
                            }
                        }
                        Button("Ok", role: .cancel) {
                            weatherViewModel.hasCallAPiError = true // Dismisses the alert.
                        }
                    }
                
                /// Conditionally displays the weather details if the weather model is available.
                if let weatherModel = weatherViewModel.weatherModel {
                    WeatherDetailsView(weatherModel: weatherModel)
                        .padding()
                }
                
                /// Shows a loading progress indicator when data is being fetched.
                if isLoading {
                    ProgressView("Loading....")
                }
                
                /// Pushes the content to the top, ensuring the layout looks good even with dynamic content.
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView(searchCity: "San Francisco")
}

