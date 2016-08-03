//
//  PetsInfoViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 15/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit
import ParseUI
import Static

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var petImageThumbnail: PFImageView!
    @IBOutlet weak var petDescTextLabel: UITextView!

    @IBOutlet weak var petNameTextLabel: UILabel!
    
    var swipeDownHandler: UISwipeGestureRecognizer?
    var tapHandler: UITapGestureRecognizer?
    
    //@IBOutlet weak var contactNumberTextLabel: UITextView!
    //@IBOutlet weak var emailTextLabel: UITextView!
    //@IBOutlet weak var contactNameTextLabel: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
   
    let dataSource = DataSource()
    
    weak var pet: Post?
    
    @IBAction func adoptMeButton(sender: UIButton) {

        contactAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        petImageThumbnail.layer.masksToBounds = true
        petImageThumbnail.layer.borderWidth = 10
        petImageThumbnail.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        swipeDownHandler = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeDownHandler?.direction = .Down
        self.view.addGestureRecognizer(swipeDownHandler!)
        
        tapHandler = UITapGestureRecognizer(target: self, action: #selector(swipeHandler))
        tapHandler!.numberOfTapsRequired = 1
        tapHandler!.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapHandler!)
        
        
        //load data
        
        petImageThumbnail.file = pet?.imageFile
        petImageThumbnail.loadInBackground()
        petNameTextLabel.text = pet?.postTitle?.uppercaseString
        petDescTextLabel.text = pet?.postDescription
        
        //resize textview

        petDescTextLabel.sizeToFit()         //
        
        
        let contactName = pet?.user?.username
        let contactNumber = pet?.user?.contactnumber
        let emailAddress = pet?.user?.email
        //contactNameTextLabel.text = pet?.user?.username
        //contactNumberTextLabel.text = pet?.user?.contactnumber
        // emailTextLabel.text = pet?.user?.email
        
        let petGender = pet?.petGender
        let hdbApproved = pet?.hdbApproved!
        
        let petBreed = pet?.petBreed
      //  let petAge = pet?.petAge
        let petType = pet?.petType
        let petOwnerType = pet?.petOwnerType
        
        let tempNumber:NSNumber = (pet?.petAge)!
        let petAgeS:String = String(format:"%.1f", tempNumber.floatValue)
        
        dataSource.tableView = tableView
        dataSource.sections = [
            Section(
                header: Section.Extremity.Title("Details"),
                rows: [
                    Row(text: "Gender: " + petGender! + " " + petType!, cellClass: Value1Cell.self),
                    Row(text: "Estimated Age: " + petAgeS + " YRS"),
                    Row(text: "Breed: " + petBreed!),
                    Row(text: "Owner Type: " + petOwnerType!),
                    Row(text: "HDB Approved: " + hdbApproved!),
                ]
            ),
            Section(
                header: Section.Extremity.Title("Contact Information "),
                rows: [
                    Row(text: "Name: " + contactName!),
                    Row(text: "Contact Number: " + contactNumber!),
                    Row(text: "Email: " + emailAddress!),
                ]
            )

        ]

    
    }
    
    
    func swipeHandler(gesture: UISwipeGestureRecognizer) {
        
        
        if gesture == swipeDownHandler {
            
            print("swiped down")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
 
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
