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
        let firstScreen = FirstScreen()
    }
    
}
