//
//  Double.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import Foundation
public extension Double
{
    public static func random(lower: Double, _ upper: Double) -> Double
    {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}
