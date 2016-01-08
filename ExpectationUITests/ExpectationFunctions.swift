//
//  Expectation2.swift
//  Expectation
//
//  Created by Ethan Sherr on 1/7/16.
//  Copyright © 2016 Ethan Sherr. All rights reserved.
//

import Foundation
import XCTest


internal enum EvaluationResult
{
    case Unknown
    case Failed
    case Success
}


//refactor idea: No protocol -- too much repeating.  Try subclassing Expectation -- All kinds conform to Expectation initializer
protocol ExpectationProtocol
{
    typealias Outcome
    var getOutcome: () -> Outcome { get }
    
    var startedEvaluating: NSDate! { get set }
    var maximumTimeAllowed: NSTimeInterval? { get set }
    var minimumTimeToPass: NSTimeInterval?  { get set }
    
    func beginEvaluationLoop() -> Void
    
    var lastEvaluationResult: EvaluationResult { get set }
    func evaluate() -> EvaluationResult
}

private let sleepInterval: NSTimeInterval = 1

private func resetExpectations<T: ExpectationProtocol>(expectations:[T], maxTime: NSTimeInterval?)
{
    let startDate = NSDate()
    expectations.forEach {
        (var exp) in
        exp.beginEvaluationLoop()
        exp.lastEvaluationResult = .Unknown
        exp.startedEvaluating = startDate
        exp.maximumTimeAllowed = exp.minimumTimeToPass ?? maxTime
    }
}


class AllExpectation<T, Z : ExpectationProtocol> :ExpectationProtocol
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
        expectations.forEach { $0.beginEvaluationLoop() }
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
            
            if failureCount == totalCount
            {
                lastEvaluationResult = .Failed
            }
            else
            if successesCount == totalCount
            {
                lastEvaluationResult = .Success
            }
        }
        return lastEvaluationResult
    }
    
    
}

func waitForFirstValidExpectation<T: ExpectationProtocol>(
    expectations: [T],
    maxTime: NSTimeInterval = 30) -> T.Outcome?
{
    resetExpectations(expectations, maxTime: maxTime)
    
    while true
    {
        print(expectations)
        let pendingExpectationsCount = expectations.filter{ $0.lastEvaluationResult == .Unknown }.count
        
        
        let passed = expectations.filter({$0.evaluate() == .Success })
        
        if let first = passed.first
        {
            XCTAssertEqual(passed.count, 1, "waitForFirstValidExpectation expects that expectations provided are mutually exclusive - \(passed.count) Expectations have passed.")
            print("✅")
            return first.getOutcome()
        }
        else
        if pendingExpectationsCount == 0 //|| NSDate().timeIntervalSinceDate(start) >= maxTime //refactor idea, move this to Expectation itself.
        {
            print("❌")
            return nil
        }
        else
        {
            print("🛌")
            wait(sleepInterval)
        }
    }
}



func waitForExpectation<T: ExpectationProtocol>(
    expectation: T,
    maxTime: NSTimeInterval = 30) -> T.Outcome?
{
    return waitForFirstValidExpectation([expectation])
}