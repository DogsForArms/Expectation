//
//  ExpectAll.swift
//  Expectation
//
//  Created by Ethan Sherr on 1/11/16.
//  Copyright © 2016 Ethan Sherr. All rights reserved.
//

import Foundation
class ExpectAll<T, Z : ExpectationProtocol> :ExpectationBase, ExpectationProtocol
{
    let expectations:[Z]
    
    typealias Outcome = T
    var getOutcome: () -> Outcome
    
    var startedEvaluating: NSDate!
    var maximumTimeAllowed: NSTimeInterval?
    var minimumTimeToPass: NSTimeInterval?
    
    
    init(expectations:[Z], getOutcome: () -> Outcome)
    {
        self.getOutcome = getOutcome
        self.expectations = expectations
        super.init()
        
        expectations.forEach
        {
            if minimumTimeToPass == nil || $0.minimumTimeToPass > minimumTimeToPass
            {
                self.minimumTimeToPass = $0.minimumTimeToPass
            }
        }
        
    }
    
    func beginEvaluationLoop()
    {
        resetExpectations(expectations, maxTime: self.minimumTimeToPass)
        expectations.forEach
        {
            (var e) -> () in
            e.beginEvaluationLoop()
            e.maximumTimeAllowed = self.maximumTimeAllowed
        }
    }
    
    var lastEvaluationResult: EvaluationResult = .Unknown
    func evaluate() -> EvaluationResult
    {
        if lastEvaluationResult == .Unknown
        {
            expectations.forEach { $0.evaluate() }
            let totalCount = expectations.count
            let successesCount = expectations.filter { $0.lastEvaluationResult == .Success }.count
            let failureCount = expectations.filter { $0.lastEvaluationResult == .Failed }.count
            
            
            
            if failureCount > 0
            {
                lastEvaluationResult = .Failed
            }
            else
            if successesCount == totalCount
            {
                lastEvaluationResult = .Success
                expectations.forEach { $0.getOutcome() }
            }
        }
        return lastEvaluationResult
    }
    
    func wait(maxTime: NSTimeInterval?) -> T?
    {
        return waitForFirstValidExpectation([self], maxTime: maxTime)
    }
    
}