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
    
    init()
    {
        container = app.any["FirstScreen"]
        goSomeplace = container.buttons["GoSomeplaceButton"]
    }
    
    func isVisible() -> Bool
    {
        return container.exists
    }
    
    func tapGoSomeplace() -> [Expectation]
    {
        goSomeplace.tap()
        //create expectation now to see where I go
        let expectationsForScreens =
        [
            RedScreen(),
            GreenScreen(),
            BlueScreen()
        ].map { (screen : Screen) -> Expectation in
            return Expectation(withCondition: screen.isVisible, otherData: screen)
        }

        return waitForFirstValidExpectation(expectationsForScreens, maxTime: 60*10)
    }
}