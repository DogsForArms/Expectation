//
//  GreenScreen.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import Foundation
import XCTest


protocol PoppableScreen : Screen
{
    typealias PopReturnType
    func pop() -> PopReturnType
}

class GreenScreen : PoppableScreen
{
    typealias PopReturnType = String
    func pop() -> String
    {
        return "aw yea"
    }
    func isVisible() -> Bool
    {
        return app.any["GreenScreen"].exists
    }
}