//
//  Expectation.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import Foundation
import XCTest

let sleepInterval: NSTimeInterval = 1

class Expectation
{
    private let condition: Void -> Bool
    private var onSuccess: (Void -> Void)?
    init(withCondition condition: Void -> Bool, onSuccess: (Void -> Void)? = nil)
    {
        self.condition = condition
        self.onSuccess = onSuccess
    }
    
    private func evaluate() -> Bool
    {
        if self.condition()
        {
            self.onSuccess?()
            return true
        }
        return false
    }
    
    func wait(maxTime: NSTimeInterval = 30) -> Bool
    {
        return waitForExpectation(self, maxTime: maxTime) != nil
    }
}

func waitForAllExpectations(
    expectations: [Expectation],
    maxTime: NSTimeInterval = 30) -> [Expectation]
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
            return []
        } else
        {
            wait(sleepInterval)
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
        print(expectations)
        let passed = expectations.filter({$0.evaluate()})
        
        if let first = passed.first
        {
            return first
        }
        else
        if NSDate().timeIntervalSinceDate(start) >= maxTime
        {
            return nil
        }
        else
        {
            wait(sleepInterval)
        }
    }
}

func waitForExpectation(
    expectation: Expectation,
    maxTime: NSTimeInterval = 30) -> Expectation?
{
    return waitForFirstValidExpectation([expectation], maxTime: maxTime)
}