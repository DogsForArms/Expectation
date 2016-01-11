//
//  ViewController.swift
//  Expectation
//
//  Created by Ethan Sherr on 12/31/15.
//  Copyright © 2015 Ethan Sherr. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var index = -1
    @IBAction func goSomeplaceAction(sender: AnyObject)
    {
        index = (1 + index) % 4
        let randomSleep = Double.random(0, 3)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        {
            NSThread.sleepForTimeInterval(randomSleep)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                if self.index == 3
                {
                    let alertView = UIAlertView(
                        title: "LOL! Sorry... no.",
                        message: "You get a big fat error message sometimes, I hope that is alright!",
                        delegate: nil,
                        cancelButtonTitle: "Yes, It is alright.")
                    alertView.accessibilityIdentifier = "RandomErrorAlert"
                    alertView.show()
                }
                else
                {
                    self.performSegueWithIdentifier("segue\(self.index+1)", sender: self)
                }
            })
        })
        

    }

    @IBAction func intermittentErrorAction(sender: AnyObject)
    {
        let willError = Double.random(0, 1) < 0.5
        let randomSleep = Double.random(0, 3)
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        {
            NSThread.sleepForTimeInterval(randomSleep)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if willError
                {
                    let alertView = UIAlertView(
                        title: "Random Error",
                        message: "Woops!", delegate: nil,
                        cancelButtonTitle: "I accept!")
                    alertView.show()
                } //otherwise nothing happens
            })
        })
    }
    
    @IBOutlet weak var changeStuffButton: UIButton!
    @IBAction func changeStuffAction(sender: AnyObject)
    {
        var changeCount = 0
        (1...55).forEach
        {
            _ in
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            {
                NSThread.sleepForTimeInterval(Double.random(0, 10))
                dispatch_async(dispatch_get_main_queue(), {
                    changeCount++
                    self.changeStuffButton.titleLabel!.text = "change \(changeCount)"
                })
            })
        }
    }
    
    
}

