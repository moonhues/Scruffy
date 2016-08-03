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
import BTNavigationDropdownMenu

class FeedsViewController: UIViewController {
    
    // MARK: Properties
    
    //    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petImageView: PFImageView!
   // @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    //@IBAction func unwindToFeeds(segue: UIStoryboardSegue) {}
    
    var swipeLeftHandler: UISwipeGestureRecognizer?
    var swipeRightHandler: UISwipeGestureRecognizer?
    var swipeUpHandler: UISwipeGestureRecognizer?
    var tapHandler: UITapGestureRecognizer?
    
    var arrayOfPets: [Post] = []
    var arrayOfLikes: [PFObject] = []
    var currentPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petImageView.layer.masksToBounds = true
        petImageView.layer.borderWidth = 10
        petImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
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
        
        swipeUpHandler = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeUpHandler?.direction = .Up
        self.view.addGestureRecognizer(swipeUpHandler!)
        
        tapHandler = UITapGestureRecognizer(target: self, action: #selector(swipeHandler))
        tapHandler!.numberOfTapsRequired = 1
        tapHandler!.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapHandler!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadDataFromParse), name: "Feed_Data_Updated", object: nil)
        
        //let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
        let items = ["Feeds", "Likes"]
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Feeds", items: items)
        
        menuView.cellBackgroundColor = UIColor.grayColor()
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellSeparatorColor = UIColor.lightGrayColor()
        
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            if indexPath == 1 {
                self!.currentPosition = 0
                self!.reloadLikesFromParse()
                print("Likes")
            } else {
                self!.currentPosition = 0
                self!.reloadDataFromParse()
                print("Feeds")
            }
        }
        
    }
    
    func reloadLikesFromParse() {
        
        let likeQuery = PFQuery(className: "Like")
        likeQuery.includeKey("fromUser")
        likeQuery.includeKey("toPost")
        likeQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        
        likeQuery.findObjectsInBackgroundWithBlock
            {(result: [PFObject]?, error: NSError?) -> Void in
                //result array is array of Like objects
                //taken likes array and mapped each element to a post object array
                
                var arrayOfPosts: [Post] = []
                for elem in result! {
                    let post = elem["toPost"] as? Post
                    if let post = post {
                        post.user! = elem["fromUser"] as! PFUser
                        arrayOfPosts.append(post)
                    }
                }
                
                
//                let postArray = result!.map {
//                    ($0["toPost"] as! Post).user = ($0["fromUser"] as! PFUser)
////                    x.user =
////                    return x
//                }
                self.arrayOfPets = arrayOfPosts
                
                likeQuery.findObjectsInBackgroundWithBlock
                    {(result: [PFObject]?, error: NSError?) -> Void in
                        self.arrayOfLikes = result!
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            
                            self.reloadView()
                        })
                }
        }
    }

    
    func reloadDataFromParse() {
        
        let allPostsQuery = Post.query()
        allPostsQuery?.includeKey("user")
        allPostsQuery?.orderByDescending("createdAt")
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
        
        if gesture == swipeUpHandler {
            
            print("swiped up")
            
            //goes backward
                
                performSegueWithIdentifier("postDetailsView", sender: nil)
        }
        
        if gesture == tapHandler {
            
            print("tapped to details view")
            performSegueWithIdentifier("postDetailsView", sender: nil)
        }
    }
    
    
    func reloadView() {
        
        print("currentposition: \(currentPosition)")
        
        //       arrayOfPets[currentPosition].downloadImage()
        petNameLabel.text = arrayOfPets[currentPosition].postTitle?.uppercaseString
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
    
    @IBAction func shareButtonTapped(sender: UIButton) {
        
        //convert PFFile to Imagefile

        let shareImage = petImageView.image
        let petName = arrayOfPets[currentPosition].postTitle
        let textToShare = petName! + " is looking for a home! Discover more adoptable dogs at ScruffyApp."
        if let myWebsite = NSURL(string: "http://scruffyapp.pagedemo.co/") {
            let objectsToShare: [AnyObject] = [textToShare, shareImage!, myWebsite]
            //let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }


}



