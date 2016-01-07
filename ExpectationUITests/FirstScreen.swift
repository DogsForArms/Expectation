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
    
    private var errorContainer: XCUIElement!
    
    init()
    {
        container = app.any["FirstScreen"]
        goSomeplace = container.buttons["GoSomeplaceButton"]
        
        errorContainer = app.alerts.element
    }
    
    func isVisible() -> Bool
    {
        return container.exists
    }
    

    
    struct TapGoSomeplaceResult_Struct
    {
        var wentToRedScreen : RedScreen?
        var wentToBlueScreen : BlueScreen?
        var wentToGreenScreen: GreenScreen?
        var errorAppearedSaying : String?
    }

    func tapGoSomeplace_Struct() -> TapGoSomeplaceResult_Struct
    {
        var result = TapGoSomeplaceResult_Struct()
        
        goSomeplace.tap()
        
        let redScreen = RedScreen()
        let blueScreen = BlueScreen()
        let greenScreen = GreenScreen()
            
        let expectations = [
            Expectation(withCondition: redScreen.isVisible) { result.wentToRedScreen = redScreen },
            Expectation(withCondition: blueScreen.isVisible) { result.wentToBlueScreen = blueScreen },
            Expectation(withCondition: greenScreen.isVisible) { result.wentToGreenScreen = greenScreen },
            Expectation(withCondition: self.errorAppeared)
            {
                result.errorAppearedSaying = self.errorContainer.staticTexts.elementBoundByIndex(0).label
            }
        ]
        
        waitForFirstValidExpectation(expectations, maxTime: 60*10)
        
        return result
    }
    
    
    
    // pattern 2, return an enum type!  The main benefit is it's easier to add valid cases, and easier for new situations to be visible!
    //For example, if there is a new case that I haven't thought of, I will fail at the end of tapGoSomeplace_Enum() on the line XCTAssertNotNil(result), 
    // then I can build a case for that result, since it is now known as a valid outcome of tapGoSomeplace
    enum TapGoSomeplaceResult_Enum
    {
        case WentToRedScreen( redScreen: RedScreen )
        case WentToBlueScreen( blueScreen: BlueScreen )
        case WentToGreenScreen( greenScreen: GreenScreen )
        case ErrorAppeared( withMessage: String )
    }
    
    
    func tapGoSomeplace_Enum() -> TapGoSomeplaceResult_Enum
    {
        var result: TapGoSomeplaceResult_Enum?
        
        goSomeplace.tap()
        
        let redScreen = RedScreen()
        let blueScreen = BlueScreen()
        let greenScreen = GreenScreen()
        
        let expectations = [
            Expectation(withCondition: redScreen.isVisible) { result = .WentToRedScreen(redScreen: redScreen) },
            Expectation(withCondition: blueScreen.isVisible) { result = .WentToBlueScreen(blueScreen: blueScreen) },
            Expectation(withCondition: greenScreen.isVisible) { result = .WentToGreenScreen(greenScreen: greenScreen) },
            Expectation(withCondition: self.errorAppeared)
            {
                let message = self.errorContainer.staticTexts.elementBoundByIndex(0).label
                result = .ErrorAppeared( withMessage: message )
            }
        ]
        
        waitForFirstValidExpectation(expectations, maxTime: 60*10)
        
        XCTAssertNotNil(result) //I like this!  Now new developers who encounter new cases will fail right here, and add their case
        
        return result!
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