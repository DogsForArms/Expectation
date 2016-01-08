//
//  NoChangeExpectation.swift
//  Expectation
//
//  Created by Ethan Sherr on 1/8/16.
//  Copyright © 2016 Ethan Sherr. All rights reserved.
//

import Foundation
class NoChangeExpectation<T, Z : Equatable> : ExpectationProtocol
{
    private let getValue:() -> Z
    private let timeInterval: NSTimeInterval
    private var lastChangeDate: NSDate!
    private var lastValue: Z!
    
    init(getValue:() -> Z, timeInterval: NSTimeInterval, getOutcome: () -> Outcome)
    {
        self.getValue = getValue
        self.timeInterval = timeInterval
        self.getOutcome = getOutcome
    }
    
    //protocol
    var startedEvaluating: NSDate!
    typealias Outcome = T
    let getOutcome: () -> Outcome
    var maximumTimeAllowed: NSTimeInterval?
    var minimumTimeToPass: NSTimeInterval?
    
    var lastEvaluationResult: EvaluationResult = .Unknown
    func evaluate() -> EvaluationResult
    {
        if lastEvaluationResult == .Unknown
        {
            let nextValue = getValue()
            let valueHasChanged = ( nextValue == lastValue )
            
            if valueHasChanged
            {
                reset()
            }
            else
                if abs(lastChangeDate.timeIntervalSinceNow) >= timeInterval
                {
                    lastEvaluationResult = .Success
            }
            if abs(startedEvaluating.timeIntervalSinceNow) > maximumTimeAllowed
            {
                lastEvaluationResult = .Failed
            }
            
            lastValue = nextValue
        }
        
        return lastEvaluationResult
    }
    
    func reset()
    {
        lastChangeDate = NSDate()
        lastValue = getValue()
    }
    
    
    func beginEvaluationLoop()
    {
        reset()
    }
}