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
    

    
    typealias TapGoSomeplaceResult =   (wentToRedScreen     : RedScreen?,
                                        wentToBlueScreen    : BlueScreen?,
                                        wentToGreenScreen   : GreenScreen?,
                                        errorAppearedSaying : String?)
    
    func tapGoSomeplace() -> TapGoSomeplaceResult
    {
        var result:TapGoSomeplaceResult = (nil, nil, nil, nil)
        
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
    
    
    func errorAppeared() -> Bool
    {
        return errorContainer.exists
    }
    func closeTheErrorAlert()
    {
        errorContainer.buttons.elementBoundByIndex(0).tap()
    }
}