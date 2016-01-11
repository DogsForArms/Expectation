//
//  SettleExpectation.swift
//  Expectation
//
//  Created by Ethan Sherr on 1/8/16.
//  Copyright © 2016 Ethan Sherr. All rights reserved.
//

import Foundation
class SettleExpectation<T, Z : Equatable> : ExpectationProtocol
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
            let valueHasChanged = ( nextValue != lastValue )
            
            print("\(nextValue) -- \(lastValue)")
            
            
            if valueHasChanged
            {
                print("🚷")
                reset()
            }
            else
            if abs(lastChangeDate.timeIntervalSinceNow) >= timeInterval
            {
                print("✅")
                lastEvaluationResult = .Success
            }
            else
            if abs(startedEvaluating.timeIntervalSinceNow) > maximumTimeAllowed
            {
                print("💀")
                lastEvaluationResult = .Failed
            }
            lastValue = nextValue
        }
        
        return lastEvaluationResult
    }
    
    private func reset()
    {
        lastChangeDate = NSDate()
        lastValue = getValue()
    }
    
    
    func beginEvaluationLoop()
    {
        reset()
    }
    func wait(maxTime: NSTimeInterval?) -> T?
    {
        return waitForFirstValidExpectation([self], maxTime: maxTime)
    }
}