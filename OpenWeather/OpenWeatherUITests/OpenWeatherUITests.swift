//
//  OpenWeatherUITests.swift
//  OpenWeatherUITests
//
//  Created by Sushant Ubale on 8/13/24.
//

import XCTest

final class OpenWeatherUITests: XCTestCase {
    
    func testNavigationAndBackButton() throws {
            let app = XCUIApplication()
            app.launch()
            app.buttons["City"].tap()
            app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"].tap()
            app.buttons["City, Country Code"].tap()
            XCTAssertTrue(app.navigationBars["Search by City and Country Code"].exists)
            app.navigationBars["Search by City and Country Code"].buttons["Back"].tap()
            app.buttons["City, Country Code, State Code"].tap()
            XCTAssertTrue(app.navigationBars["Search by City, State & Country Code"].exists)
            app.navigationBars["Search by City, State & Country Code"].buttons["Back"].tap()
        }
}
