//
//  ExpectationUITests.swift
//  ExpectationUITests
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import XCTest

class ExpectationUITests: XCTestCase {
        
    override func setUp()
    {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown()
    {
        app.terminate()
        super.tearDown()
    }
    
    func testTap_Structs()
    {
        var times = 0
        while (times < 5)
        {
            times++
            goSomeplaceThenGoBack_Structs()
        }
    }
    func testTap_Enums()
    {
        var times = 0
        while (times < 5)
        {
            times++
            goSomeplaceThenGoBack_Enums()
        }
    }
    
    
    // pattern 1, structs
    func goSomeplaceThenGoBack_Structs()
    {
        let firstScreen = FirstScreen()
        let result = firstScreen.tapGoSomeplace_Struct()
        
        //typing "result. brings up intellisence
        if let blueScreen = result.wentToBlueScreen
        {
            blueScreen.pop()
        }
        else
        if let greenScreen = result.wentToGreenScreen
        {
            greenScreen.pop()
        }
        else
        if let redScreen = result.wentToRedScreen
        {
            redScreen.pop()
        } else
        if let errMessage = result.errorAppearedSaying
        {
            firstScreen.closeTheErrorAlert()
        }
        else
        {
            XCTFail("Unexpected scenario \(result)")
        }
        
    }
    
    
    //pattern 2, enums
    func goSomeplaceThenGoBack_Enums()
    {
        let firstScreen = FirstScreen()
        let result = firstScreen.tapGoSomeplace_Enum()
        
        
        switch result
        {
            //intellisence too
            case .WentToRedScreen(redScreen: let redScreen):
                redScreen.pop()
            case .WentToBlueScreen(blueScreen: let blueScreen):
                blueScreen.pop()
            case .WentToGreenScreen(greenScreen: let greenScreen):
                greenScreen.pop()
            case .ErrorAppearedSaying:
                firstScreen.closeTheErrorAlert()
            default:
                print("Those were all the cases!  If there is another one that is not known, tapGoSomeplace_Enum() will XCTAssert!  It brings the developer to that point to consider if there is now a new case to be added to that function.")
        }
    }
    
}
