//
//  Expectation.swift
//  Expectation
//
//  Created by Ethan Sherr on 1/8/16.
//  Copyright © 2016 Ethan Sherr. All rights reserved.
//

import Foundation
class Expect<T> : ExpectationProtocol
{
    private let condition: () -> Bool
    
    init(condition: () -> Bool, getOutcome: () -> Outcome)
    {
        self.condition = condition
        self.getOutcome = getOutcome
    }
    
    
    //protocol
    typealias Outcome = T
    let getOutcome: () -> Outcome
    var startedEvaluating: NSDate!
    var maximumTimeAllowed: NSTimeInterval?
    var minimumTimeToPass: NSTimeInterval?
    
    var lastEvaluationResult: EvaluationResult = .Unknown
    func evaluate() -> EvaluationResult
    {
        if lastEvaluationResult == .Unknown
        {
            if condition()
            {
                lastEvaluationResult = .Success
            }
            else
                if abs(startedEvaluating.timeIntervalSinceNow) > maximumTimeAllowed
                {
                    lastEvaluationResult = .Failed
            }
        }
        
        return lastEvaluationResult
    }
    func beginEvaluationLoop() {}
    
    func wait(maxTime: NSTimeInterval?) -> T?
    {
        return waitForFirstValidExpectation([self], maxTime: maxTime)
    }
}