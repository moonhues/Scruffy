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
    
    var swipeDownHandler: UISwipeGestureRecognizer?
    
    @IBOutlet weak var contactNumberTextLabel: UITextView!
    @IBOutlet weak var emailTextLabel: UITextView!
    @IBOutlet weak var contactNameTextLabel: UITextView!
    
    weak var pet: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        swipeDownHandler = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeDownHandler?.direction = .Down
        
        self.view.addGestureRecognizer(swipeDownHandler!)
        
//        petImageThumbnail.addGestureRecognizer(swipeDownHandler!)
        
        //load data
        
        petImageThumbnail.file = pet?.imageFile
        petImageThumbnail.loadInBackground()
        contactNameTextLabel.text = pet?.user?.username
        petDescTextLabel.text = pet?.postDescription
        contactNumberTextLabel.text = pet?.user?.contactnumber
        emailTextLabel.text = pet?.user?.email
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func swipeHandler(gesture: UISwipeGestureRecognizer) {
        
        
        if gesture == swipeDownHandler {
            
            print("swiped down")
            
            //goes up
            
            //let pet = arrayOfPets[currentPosition]
            //PostDetailsViewController.pet = pet
//            performSegueWithIdentifier("unwindToFeeds", sender: nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
