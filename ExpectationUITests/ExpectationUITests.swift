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
        while (times < 4)
        {
            times++
            goSomeplaceThenGoBack()
        }
    }
    
    func goSomeplaceThenGoBack()
    {
        let firstScreen = FirstScreen()
        let validExpectations = firstScreen.tapGoSomeplace()
        
        XCTAssertEqual(validExpectations.count, 1)
        
        switch validExpectations[0].otherData
        {
            case let redScreen as RedScreen:
                print("it was a redScreen")
                redScreen.pop()
            case let blueScreen as BlueScreen:
                print("do stuff with blueScreen")
                blueScreen.pop()
            case let greenScreen as GreenScreen:
                print("do stuff with greenScreen")
                greenScreen.pop()
            default:
                XCTFail("Something unexpected happened when tappingGoSomeplace()")
        }
        
    }
    
}
