//
//  MenuViewController.swift
//  BlackJack
//
//  Created by Ari on 9/20/15.
//  Copyright © 2015 Ari. All rights reserved.
//

import Foundation

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var player1_input: UITextField!
    @IBOutlet weak var player2_input: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "toGame") {
            // pass data to next view
            let svc = segue!.destinationViewController as! ViewController;
            svc.player1_name = String(player1_input.text!)
            svc.player2_name = String(player2_input.text!)
        }
    }
    
}