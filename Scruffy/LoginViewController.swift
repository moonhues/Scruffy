//
//  ViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 7/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit
import Parse
import JSSAlertView


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginAction(sender: AnyObject) {
        
            let username = self.userNameField.text
            let password = self.passwordField.text
            
            // Validate the text fields
        
            if username?.characters.count < 5 {
                /*
                let alertController = UIAlertController(title: "Username", message: "Username must be more than 5 characters", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                presentViewController(alertController, animated: true, completion: nil)
             */
                JSSAlertView().show(
                    self, // the parent view controller of the alert
                    title: "Usernames must have at leaast 5 characters" // the alert's title
                )
                
            } else if password!.characters.count < 8 {
                
                
            /*
                let alertController = UIAlertController(title: "Password", message: "Password must be at least 8 characters", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                presentViewController(alertController, animated: true, completion: nil)
                */
                
                JSSAlertView().show(
                    self, // the parent view controller of the alert
                    title: "Passwords must have at least 8 characters" // the alert's title
                )
                
            } else {
                // Run a spinner to show a task in progress
                let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
                spinner.startAnimating()
                
                // Send a request to login
                PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
                    
                    // Stop the spinner
                    spinner.stopAnimating()
                    
                    if ((user) != nil) {
                        /*let alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                        alert.show() */
                        
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.performSegueWithIdentifier("toFeeds", sender: nil)
                        })
                        
                    } else {
                        /*
                        let alertController = UIAlertController(title: "Login error", message: "Wrong username or password.", preferredStyle: .Alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)*/
                        JSSAlertView().show(
                            self, // the parent view controller of the alert
                            title: "Wrong username or password. Please try again." // the alert's title
                        )
                    }
                })
    }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ddd")
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
         do {
         try PFUser.logInWithUsername("veronica", password: "veronica")
         } catch {
         print("Unable to log in")
         }
         
         if let currentUser = PFUser.currentUser() {
         print("\(currentUser.username!) logged in successfully")
         } else {
         print("No logged in user :(")
         }*/
         
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}


