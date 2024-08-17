//
//  InitialView.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/13/24.
//

import SwiftUI

struct InitialView: View {
    /// A dictionary mapping search options to their corresponding views.
    /// The keys are the titles of the search options, and the values are the views wrapped in `AnyView`.
    let sections: [String: AnyView] = [
        "City": AnyView(ContentView()), // Navigates to `ContentView` for searching by City.
        "City, Country Code": AnyView(CityCountryCodeView()), // Navigates to `CityCountryCodeView` for searching by City and Country Code.
        "City, Country Code, State Code": AnyView(CityStateCountryCodeView()) // Navigates to `CityStateCountryCodeView` for searching by City, Country Code, and State Code.
    ]

    var body: some View {
        /// The main navigation structure that allows for deep navigation hierarchies.
        NavigationStack {
            VStack(alignment: .leading) {
                /// The main title of the view, displayed at the top.
                Text("Weather")
                    .font(.largeTitle).bold() // Large and bold font for prominence.
                    .padding() // Adds padding around the title.

                /// A subheading prompting the user to choose a search option.
                Text("Search by")
                    .padding(.horizontal) // Horizontal padding for alignment with the content.
                    .padding(.top, 20) // Adds padding to the top for spacing from the title.

                /// A vertical stack containing the navigation links to different search options.
                VStack {
                    /// Iterates over the `sections` dictionary to create a navigation link for each search option.
                    ForEach(Array(sections), id: \.key) { key, view in
                        NavigationLink(destination: view) {
                            navigationLabel(text: key) // Custom label for each navigation link.
                        }
                    }
                }
                Spacer() // Pushes content to the top, leaving space at the bottom.
            }
            .background(Gradient(colors: [Color.white, Color(hex: 0x7484B8)])) // Sets a gradient background for the view.
        }
    }

    /// `navigationLabel` is a helper method that creates a styled label for each navigation link.
    /// - Parameter text: The text to display in the label.
    /// - Returns: A styled `HStack` containing the text and a chevron image.
    fileprivate func navigationLabel(text: String) -> some View {
        let backgroundColor: Color = Color(hex: 0x4862A7) // The background color for the label.
        return HStack {
            Text(text) // The main text of the label.
            Spacer() // Spacer to push the text to the left and the image to the right.
            Image(systemName: "chevron.right") // A chevron image indicating the link direction.
        }
        .fontWeight(.semibold) // Semi-bold font for readability.
        .frame(maxWidth: .infinity) // Expands the label to the full width of the parent view.
        .padding(.horizontal, 15) // Adds horizontal padding inside the label.
        .padding(.vertical, 20) // Adds vertical padding inside the label.
        .background(backgroundColor) // Sets the background color of the label.
        .cornerRadius(10) // Rounds the corners of the label.
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(backgroundColor, lineWidth: 1.5) // Adds a border around the label.
        )
        .foregroundColor(.white) // Sets the text and image color to white.
        .padding(.horizontal) // Adds horizontal padding around the label.
    }
}



#Preview {
    InitialView()
}
