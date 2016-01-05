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
        index = (1 + index) % 3
        let randomSleep = Double.random(0, 3)
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
        {
            NSThread.sleepForTimeInterval(randomSleep)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("segue\(self.index+1)", sender: self)
            })
        })
        

    }

}
