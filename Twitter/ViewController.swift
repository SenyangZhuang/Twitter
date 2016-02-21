//
//  ViewController.swift
//  Twitter
//
//  Created by Senyang Zhuang on 2/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion(){
            (user: User?, error: NSError?) in
            if user != nil{
                //perform my segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            
            }else{
                //handle login error
            }
        
        }
        
        
        

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

