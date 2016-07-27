//
//  UserProfileViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 15/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit
import Parse

class UserProfileViewController: UIViewController {
    
    var userProfile: [PFObject] = []
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPhoneNo: UITextField!
    
    //var userObject = [PFObject](className: "User")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.text = PFUser.currentUser()?.username
        userEmailTextField.text = PFUser.currentUser()?.email
        userPhoneNo.text = PFUser.currentUser()?.contactnumber
        
    }
    
    @IBAction func updateUserProfileButton(sender: UIButton) {
        
        //        // Create a pointer to an object of class Point with id dlkj83d
        //        var point = PFObject.object [PFObject objectWithoutDataWithClassName:@"Point" objectId:@"dlkj83d"];
        //
        //        // Set a new value on quantity
        //        [point setObject:@6 forKey:@"quantity"];
        //
        //        // Save
        //        [point save];
        
        let userObject = PFUser.currentUser()!
        userObject["username"] = userNameTextField.text
        userObject["email"] = userEmailTextField.text
        userObject["contactnumber"] = userPhoneNo.text
        userObject.saveInBackgroundWithBlock { (success, error) in
            
            if (success) {
                print ("saved to user!")
                
            } else {
                print ("failed to save user")
            }
        }
        
    }
}
