//
//  FirstScreen.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import Foundation
import XCTest

class FirstScreen : Screen
{
    private var container: XCUIElement!
    private var goSomeplace: XCUIElement!
    private var intermittentErrorButton: XCUIElement!
    
    private var errorContainer: XCUIElement!
    
    init()
    {
        container = app.any["FirstScreen"]
        goSomeplace = container.buttons["GoSomeplaceButton"]
        intermittentErrorButton = container.buttons["intermittentErrorButton"]
        
        errorContainer = app.alerts.element
    }
    
    func isVisible() -> Bool
    {
        return container.exists
    }
    
    enum TapWentSomeplaceResult
    {
        case WentToRedScreen( redScreen: RedScreen )
        case WentToGreenScreen( greenScreen: GreenScreen )
        case WentToBlueScreen( blueScreen: BlueScreen )
        case ErrorAppeared
    }
    func tapGoSomeplace() -> TapWentSomeplaceResult
    {
        goSomeplace.tap()
        
        let redScreen = RedScreen()
        let greenScreen = GreenScreen()
        let blueScreen = BlueScreen()
        
        let exp = [
            Expectation(condition: redScreen.isVisible)   { TapWentSomeplaceResult.WentToRedScreen( redScreen: redScreen) },
            Expectation(condition: greenScreen.isVisible) { TapWentSomeplaceResult.WentToGreenScreen( greenScreen: greenScreen) },
            Expectation(condition: blueScreen.isVisible)  { TapWentSomeplaceResult.WentToBlueScreen( blueScreen: blueScreen) },
            Expectation(condition: errorAppeared) { TapWentSomeplaceResult.ErrorAppeared }
        ]
        
        let result = waitForFirstValidExpectation(exp)
        
        XCTAssertNotNil(result)
        
        return result!
    }
    
    
    enum TapIntermittentErrorResult
    {
        case ErrorAppeared
        case NothingHappened
    }
    func tapIntermittentError() -> TapIntermittentErrorResult
    {
        intermittentErrorButton.tap()
        
        let exp = [
            NothingHappenedExpectation(somethingHappenedBlock: errorAppeared, within: 5) { TapIntermittentErrorResult.NothingHappened }
        ]
        
        if let result = waitForFirstValidExpectation(exp)
        {
            return result
        }
        else
        {
            return TapIntermittentErrorResult.NothingHappened
        }
    }
    
    
    func errorAppeared() -> Bool
    {
        return errorContainer.exists
    }
    func closeTheErrorAlert()
    {
        errorContainer.buttons.elementBoundByIndex(0).tap()
    }
}
