//
//  Expectation.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import Foundation
import XCTest

class Expectation
{
    let otherData: Any? // maybe this is a string, or some object with properties
    private let condition: Void -> Bool
    init(withCondition condition: Void -> Bool, otherData: Any? = nil)
    {
        self.condition = condition
        self.otherData = otherData
    }
    
    func evaluate() -> Bool
    {
        return self.condition()
    }
    
    func wait(maxTime: NSTimeInterval = 30) -> Bool
    {
        return waitForExpectation(self, maxTime: maxTime) != nil
    }
}

func waitForAllExpectations(
    expectations: [Expectation],
    maxTime: NSTimeInterval = 30) -> [Expectation]?
{
    let start = NSDate()

    var satisfiedExpectations = Array<Expectation>()
    var unsatisfiedExpectations = Array(expectations)
    
    while true
    {
        let partition = unsatisfiedExpectations.partition(0..<unsatisfiedExpectations.count, isOrderedBefore: { (e1, _) -> Bool in
            return e1.evaluate()
        })
        
        satisfiedExpectations = Array(unsatisfiedExpectations[0..<partition])
        unsatisfiedExpectations = Array(unsatisfiedExpectations[partition..<unsatisfiedExpectations.count])
        
        if satisfiedExpectations.count == expectations.count
        {
            return satisfiedExpectations
        }
        else
        if NSDate().timeIntervalSinceDate(start) >= maxTime
        {
            return nil
        }
    }
}

func waitForFirstValidExpectation(
    expectations: [Expectation],
    maxTime: NSTimeInterval = 30) -> Expectation?
{
    let start = NSDate()
    while true
    {
        let passed = expectations.filter({$0.condition()})
        
        if let first = passed.first
        {
            return first
        }
        else
        if NSDate().timeIntervalSinceDate(start) >= maxTime
        {
            return nil
        }
    }
}

func waitForExpectation(
    expectation: Expectation,
    maxTime: NSTimeInterval = 30) -> Expectation?
{
    return waitForFirstValidExpectation([expectation], maxTime: maxTime)
}


