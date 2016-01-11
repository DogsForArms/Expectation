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
    private var changeStuffButton: XCUIElement!
    private var changeStuffLabel: XCUIElement!
    
    private var errorContainer: XCUIElement!
    
    init()
    {
        container = app.any["FirstScreen"]
        goSomeplace = container.buttons["GoSomeplaceButton"]
        intermittentErrorButton = container.buttons["intermittentErrorButton"]
        
        changeStuffButton = container.buttons["changeStuffButton"]
        changeStuffLabel = container.any["changeStuffLabel"]
        
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
    
    
    
    func tapChangeStuffButton()
    {
        changeStuffButton.tap()
        
        let noChangeInButton = NoChangeExpectation(getValue: {self.changeStuffButton.label}, timeInterval: 10) { return true }
        let noChangeInLabel = NoChangeExpectation(getValue: {self.changeStuffLabel.label}, timeInterval: 20) { return true }
        let expectations = [noChangeInButton, noChangeInLabel]
        
        guard let _ = (AllExpectation(expectations: expectations) { return true} ).wait(60)
        else
        {
            XCTFail();
            return
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
    
    func doEverything()
    {
        goSomeplace.tap()
    }
}
