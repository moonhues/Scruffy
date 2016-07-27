//
//  FeedsViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 13/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit
import ConvenienceKit
import Parse
import ParseUI
import Bond

class FeedsViewController: UIViewController {
    
    // MARK: Properties
    
    //    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petImageView: PFImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    //@IBAction func unwindToFeeds(segue: UIStoryboardSegue) {}
    
    var swipeLeftHandler: UISwipeGestureRecognizer?
    var swipeRightHandler: UISwipeGestureRecognizer?
    //var swipeUpHandler: UISwipeGestureRecognizer?
    var tapHandler: UITapGestureRecognizer?
    
    var arrayOfPets: [Post] = []
    var arrayOfLikes: [PFObject] = []
    var currentPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // view.addSubview(<#T##view: UIView##UIView#>)
        
        reloadDataFromParse()
        
        //Swipe Gesture
        swipeLeftHandler = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeLeftHandler?.direction = .Left
        self.view.addGestureRecognizer(swipeLeftHandler!)
        
        swipeRightHandler = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeRightHandler?.direction = .Right
        self.view.addGestureRecognizer(swipeRightHandler!)
        
        tapHandler = UITapGestureRecognizer(target: self, action: #selector(swipeHandler))
        tapHandler!.numberOfTapsRequired = 1
        tapHandler!.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapHandler!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadDataFromParse), name: "Feed_Data_Updated", object: nil)
    }
    
    func reloadDataFromParse() {
        
        let allPostsQuery = Post.query()
        allPostsQuery?.includeKey("user")
        allPostsQuery?.findObjectsInBackgroundWithBlock
            {(result: [PFObject]?, error: NSError?) -> Void in
                self.arrayOfPets = result as? [Post] ?? []
                
                //get all Post ids liked by user
                let likeQuery = PFQuery(className: "Like")
                likeQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
                
                likeQuery.findObjectsInBackgroundWithBlock
                    {(result: [PFObject]?, error: NSError?) -> Void in
                        self.arrayOfLikes = result!
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                            self.reloadView()
                        })
                }
        }
    }
    
    
    // Generates a comma separated list of usernames from an array (e.g. "User1, User2")
    func stringFromUserList(userList: [PFUser]) -> String {
        let usernameList = userList.map { user in user.username! }
        let commaSeparatedUserList = usernameList.joinWithSeparator(", ")
        
        return commaSeparatedUserList
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func swipeHandler(gesture: UISwipeGestureRecognizer) {
        
        if gesture == swipeLeftHandler {
            
            print("swiped left")
            
            //goes forward
            if currentPosition < arrayOfPets.count - 1 {
                currentPosition = currentPosition + 1
                reloadView()
            }
        }
        
        if gesture == swipeRightHandler {
            
            print("swiped right")
            
            //goes backward
            if currentPosition > 0 {
                currentPosition = currentPosition - 1
                reloadView()
            }
        }
        
        
        if gesture == tapHandler {
            
            print("tapped to details view")
            performSegueWithIdentifier("postDetailsView", sender: nil)
        }
    }
    
    
    func reloadView() {
        
        print("currentposition: \(currentPosition)")
        
        //       arrayOfPets[currentPosition].downloadImage()
        petNameLabel.text = arrayOfPets[currentPosition].postTitle
        
        petImageView.file = arrayOfPets[currentPosition].imageFile
        petImageView.loadInBackground()
        
        //        petImageView.image = arrayOfPets[currentPosition].image.value
        
        //check for liked status
        
        let currentPost = arrayOfPets[currentPosition]
        
        if (isPostLiked(currentPost)) {
            
            //set it to liked image
            likeButton.selected = true
        }
        else {
            
            //set it to normal image
            likeButton.selected = false
        }
    }
    
    func isPostLiked(post: Post) -> Bool {
        
        let currentPostObjectId = post.objectId
        
        for likeObject in arrayOfLikes {
            
            let likedPost = likeObject["toPost"] as! PFObject
            let likedPostId = likedPost.objectId
            
            if likedPostId == currentPostObjectId {
                
                return true
            }
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "postDetailsView" {
            
            let destVC = segue.destinationViewController as! PostDetailsViewController
            destVC.pet = arrayOfPets[currentPosition]
        }
    }
    
    //MARK: Actions
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        let currentPost = arrayOfPets[currentPosition]
        let user = PFUser.currentUser()!
        
        if (isPostLiked(currentPost)) {
            
            //dislike it now
            ParseHelper.unlikePost(user, post: currentPost)
            likeButton.selected = false
        }
        else {
            
            //like it now
            ParseHelper.likePost(user, post: currentPost)
            likeButton.selected = true
        }
        
        
    }
    
}



