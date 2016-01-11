//
//  SettleExpectation.swift
//  Expectation
//
//  Created by Ethan Sherr on 1/8/16.
//  Copyright © 2016 Ethan Sherr. All rights reserved.
//

import Foundation
class ExpectSettle<T, Z : Equatable> : ExpectationBase, ExpectationProtocol
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
        super.init()
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
            
            let timeSinceLastSettleAttempt = abs(lastChangeDate.timeIntervalSinceNow)
            let timeSinceStart = abs(startedEvaluating.timeIntervalSinceNow)
            
            if valueHasChanged
            {
                log("🚷 change detected, Reset")
                reset()
            }
            else
            if timeSinceLastSettleAttempt >= timeInterval
            {
                log("🚙 settled in \(timeSinceStart) seconds")
                lastEvaluationResult = .Success
            }
            else
            if timeSinceStart > maximumTimeAllowed
            {
                log("💀")
                lastEvaluationResult = .Failed
            }
            else
            {
                log("⏸ \(Int(100*timeSinceLastSettleAttempt/timeInterval))% - (\(Int(timeSinceLastSettleAttempt))s/\(timeInterval)s)")
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