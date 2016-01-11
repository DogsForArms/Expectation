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
    
    func testTapABunchOfTimes()
    {
        var times = 0
        while (times < 5)
        {
            times++
            goSomeplaceThenGoBack()
        }
    }
    
    func goSomeplaceThenGoBack()
    {
        let firstScreen = FirstScreen()
        let result = firstScreen.tapGoSomeplace()
        
        switch result
        {
            case .WentToRedScreen(redScreen: let redScreen):
                redScreen.pop()
            
            case .WentToGreenScreen(greenScreen: let greenScreen):
                greenScreen.pop()
            
            case .WentToBlueScreen(blueScreen: let blueScreen):
                    blueScreen.pop()
            default:
                print("WOOPS NOT EXPECTED... fail with XCTFail()")
                //XCTFail()
        }
    }
    
    func testIntermittentError()
    {
        let firstScreen = FirstScreen()
        let result = firstScreen.tapIntermittentError()
        
        guard case .NothingHappened = result
        else
        {
            XCTFail("The error appeared... \(result)")
            return;
        }
    }
    
    
    func testLabelSettles()
    {
        let firstScreen = FirstScreen()
        firstScreen.tapChangeStuffButton()
    }
    
    
    func testAllExpectation()
    {
        let firstScreen = FirstScreen()
        firstScreen.doEverything()
    }
    
    
    
    
    
    
    
    
    
}
