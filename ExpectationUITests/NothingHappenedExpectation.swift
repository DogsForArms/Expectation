//
//  NothingHappenedExpectation.swift
//  Expectation
//
//  Created by Ethan Sherr on 1/8/16.
//  Copyright © 2016 Ethan Sherr. All rights reserved.
//

import Foundation
class NothingHappenedExpectation<T> : ExpectationProtocol
{
    private let somethingHappenedBlock: () -> Bool
    private let timeInterval: NSTimeInterval
    
    
    init(somethingHappenedBlock: () -> Bool, within timeInterval: NSTimeInterval, getOutcome: () -> Outcome)
    {
        self.somethingHappenedBlock = somethingHappenedBlock
        self.timeInterval = timeInterval
        self.getOutcome = getOutcome
    }
    
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
            if somethingHappenedBlock()
            {
                lastEvaluationResult = .Failed
            }
            else
            if abs(startedEvaluating.timeIntervalSinceNow) >= timeInterval
            {
                lastEvaluationResult = .Success
            }
            else if abs(startedEvaluating.timeIntervalSinceNow) > maximumTimeAllowed
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