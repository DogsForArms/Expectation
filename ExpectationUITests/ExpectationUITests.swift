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
    
    func testTap()
    {
        var times = 0
        while (times < 8)
        {
            times++
            goSomeplaceThenGoBack()
        }
    }
    
    func goSomeplaceThenGoBack()
    {
        let firstScreen = FirstScreen()
        let result = firstScreen.tapGoSomeplace()
        
        print("RESULT: \(result)")
        
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
    
}
