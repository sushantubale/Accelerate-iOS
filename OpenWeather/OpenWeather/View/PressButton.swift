//
//  PressButton.swift
//  OpenWeather
//
//  Created by Sushant Ubale on 8/15/24.
//

import Foundation
import SwiftUI

/// `PressButton` is a custom button style that changes appearance based on the button's press state.
/// When the button is pressed, the background color changes to orange. When not pressed, the background color is blue.
struct PressButton: ButtonStyle {
    /// Defines the type of view that this button style will return.
    typealias Body = Button

    /// Creates the body of the button based on its configuration.
    /// - Parameter configuration: The configuration of the button, which includes the current state of the button (e.g., whether it is pressed).
    /// - Returns: A view that represents the body of the button, styled according to its state.
    func makeBody(configuration: Self.Configuration) -> some View {
        if configuration.isPressed {
            /// The button's appearance when it is pressed:
            /// - Background color changes to orange.
            /// - Text color remains white.
            /// - Button is clipped to a rounded rectangle shape.
            return configuration
                .label
                .padding() // Adds padding around the label.
                .background(Color.orange) // Sets the background color to orange when pressed.
                .foregroundColor(Color.white) // Sets the text color to white.
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Clips the button to a rounded rectangle with a corner radius of 10.
        } else {
            /// The button's appearance when it is not pressed:
            /// - Background color is blue.
            /// - Text color remains white.
            /// - Button is clipped to a rounded rectangle shape.
            return configuration
                .label
                .padding() // Adds padding around the label.
                .background(Color.blue) // Sets the background color to blue when not pressed.
                .foregroundColor(Color.white) // Sets the text color to white.
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Clips the button to a rounded rectangle with a corner radius of 10.
        }
    }
}


extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
