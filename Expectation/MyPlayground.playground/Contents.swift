//: Playground - noun: a place where people can play

import Cocoa

class Greeter
{
    lazy var someBlock: () -> () = {
        
    }
}

let g = Greeter()

g.someBlock = {
    print("lol, Allen...")
}

//greeter2.greet(name: "Ethan", arg2: 5, arg3: "Lol")
//greeter1.greet(name: "Rolin", arg2: 42, arg3: "Lol")