//
//  RedScreen.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import Foundation
import XCTest



class RedScreen : Screen
{
    func pop()
    {
        app.navigationBars.buttons.elementBoundByIndex(0).tap()
    }
    func isVisible() -> Bool
    {
        return app.any["RedScreen"].exists
    }

    
}