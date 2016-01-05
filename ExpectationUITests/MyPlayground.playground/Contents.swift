//: Playground - noun: a place where people can play

import Cocoa

public extension Double
{
    public static func random(lower: Double, _ upper: Double) -> Double
    {
        return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

class Thing : CustomStringConvertible
{
    var value:Bool
    init(v: Bool)
    {
        self.value = v
    }
    init()
    {
        self.value = Double.random(0,1) > 0.5
    }
    var description:String {
        return "\(value)"
    }
}


var thingArray = [Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), Thing(), ]

let sentinel = thingArray.partition(0..<thingArray.count) { (t1, t2) -> Bool in
    return t1.value
}

print(Array<Thing>(thingArray[0..<sentinel]))
print(Array<Thing>(thingArray[sentinel..<thingArray.count]))




