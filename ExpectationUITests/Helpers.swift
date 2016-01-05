//
//  Helpers.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import Foundation
import XCTest

func wait(duration: NSTimeInterval)
{
    NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow: duration))
}

let app = XCUIApplication()

extension XCUIElement
{
    var any:XCUIElementQuery
    {
        return self.descendantsMatchingType(.Any)
    }
}
extension XCUIElementQuery
{
    var any:XCUIElementQuery
    {
        return self.descendantsMatchingType(.Any)
    }
}