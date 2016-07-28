//
//  PetsInfoViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 15/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit
import ParseUI

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var petImageThumbnail: PFImageView!
    @IBOutlet weak var petDescTextLabel: UITextView!
    
    @IBOutlet weak var petNameTextLabel: UILabel!
    
    @IBOutlet weak var contactHeaderTextLabel: UILabel!
    
    //var swipeDownHandler: UISwipeGestureRecognizer?
    var tapHandler: UITapGestureRecognizer?
    
    @IBOutlet weak var contactNumberTextLabel: UITextView!
    @IBOutlet weak var emailTextLabel: UITextView!
    @IBOutlet weak var contactNameTextLabel: UITextView!
    
    weak var pet: Post?
    
    @IBAction func adoptMeButton(sender: UIButton) {

        contactAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /*
        swipeDownHandler = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeDownHandler?.direction = .Down
        self.view.addGestureRecognizer(swipeDownHandler!)*/
        
        tapHandler = UITapGestureRecognizer(target: self, action: #selector(swipeHandler))
        tapHandler!.numberOfTapsRequired = 1
        tapHandler!.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapHandler!)
        
        
        //load data
        
        petImageThumbnail.file = pet?.imageFile
        petImageThumbnail.loadInBackground()
        contactNameTextLabel.text = pet?.user?.username
        petNameTextLabel.text = pet?.postTitle
        petDescTextLabel.text = pet?.postDescription
        contactNumberTextLabel.text = pet?.user?.contactnumber
        emailTextLabel.text = pet?.user?.email
        
    }
    
    
    func swipeHandler(gesture: UISwipeGestureRecognizer) {
        
        /*
        if gesture == swipeDownHandler {
            
            print("swiped down")
            self.dismissViewControllerAnimated(true, completion: nil)
        }*/
        if gesture == tapHandler {
            
            print("tapped done")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func contactAction() {
        
        let callString = "tel://" + (pet?.user?.contactnumber)!
        
        let alertController = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let callAction = UIAlertAction(title: "Call", style: .Default) { (action) in
            let url:NSURL = NSURL(string: callString)!
            UIApplication.sharedApplication().openURL(url)
        }
        alertController.addAction(callAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}
