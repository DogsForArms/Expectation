//
//  Screen.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import Foundation

protocol Screen
{
    /**
     It is a function to see if the screen isVisible, returns true if it is.
    */
    func isVisible() -> Bool
}

protocol PoppableScreen : Screen
{
    func pop()
}