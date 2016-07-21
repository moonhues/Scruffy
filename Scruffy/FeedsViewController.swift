//
//  FeedsViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 13/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit


class FeedsViewController: UIViewController {
    
     // MARK: Properties

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    
    @IBAction func unwindToFeedsView(segue: UIStoryboardSegue) {}
    
    var arrayOfPets: [NSDictionary] = []
    
    var swipeLeftHandler: UISwipeGestureRecognizer?
    var swipeRightHandler: UISwipeGestureRecognizer?
    
    var currentPosition: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // view.addSubview(<#T##view: UIView##UIView#>)
        
        let newPet = NSMutableDictionary()
        newPet["name"] = "Afya"
        newPet["image"] = "Afya"
        arrayOfPets.append(newPet)
        
        let newPet2 = NSMutableDictionary()
        newPet2["name"] = "Benny"
        newPet2["image"] = "Benny"
        arrayOfPets.append(newPet2)
        
        let newPet3 = NSMutableDictionary()
        newPet3["name"] = "Anita"
        newPet3["image"] = "Anita"
        arrayOfPets.append(newPet3)
        
        let newPet4 = NSMutableDictionary()
        newPet4["name"] = "Chanel"
        newPet4["image"] = "Chanel"
        arrayOfPets.append(newPet4)
        
       petNameLabel.text = newPet["name"] as? String
       petImageView.image = UIImage(named: newPet["image"] as! String)
        
        
        //Swipe Gesture
        swipeLeftHandler = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeLeftHandler?.direction = .Left
        petImageView.addGestureRecognizer(swipeLeftHandler!)
        
        swipeRightHandler = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeRightHandler?.direction = .Right
        petImageView.addGestureRecognizer(swipeRightHandler!)
    }
    
    
    func swipeHandler(gesture: UISwipeGestureRecognizer) {
        
        if gesture == swipeLeftHandler {
            
            print("swiped left")
            
            //goes forward
            if currentPosition < arrayOfPets.count - 1 {
                currentPosition = currentPosition + 1
                
                let pet = arrayOfPets[currentPosition]
                reloadView(pet)
            }
        }
        
        if gesture == swipeRightHandler {
            
            print("swiped right")
            
            //goes backward
            if currentPosition > 0 {
                currentPosition = currentPosition - 1
                
                let pet = arrayOfPets[currentPosition]
                reloadView(pet)
            }
        }
    }
    
    func reloadView(petDictionary: NSDictionary) {
        
        print("currentposition: \(currentPosition)")
        
        petNameLabel.text = petDictionary["name"] as? String
        petImageView.image = UIImage(named: petDictionary["image"] as! String)
    }
    
    
}


import UIKit

import ConvenienceKit
import Parse

class TimelineViewController: UIViewController, TimelineComponentTarget {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photoTakingHelper: PhotoTakingHelper?
    var timelineComponent: TimelineComponent<Post, TimelineViewController>!
    
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineComponent = TimelineComponent(target: self)
        self.tabBarController?.delegate = self
    }
    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper =
            PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
                let post = Post()
                // 1
                post.image.value = image!
                post.uploadPost()
        }
    }
    
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
        ParseHelper.timelineRequestForCurrentUser(range) {
            (result: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            let posts = result as? [Post] ?? []
            completionBlock(posts)
        }
    }
    
    // MARK: UIActionSheets
    
    func showActionSheetForPost(post: Post) {
        if (post.user == PFUser.currentUser()) {
            showDeleteActionSheetForPost(post)
        } else {
            showFlagActionSheetForPost(post)
        }
    }
    
    func showDeleteActionSheetForPost(post: Post) {
        let alertController = UIAlertController(title: nil, message: "Do you want to delete this post?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            post.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.timelineComponent.removeObject(post)
                } else {
                    // restore old state
                    self.timelineComponent.refresh(self)
                }
            })
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showFlagActionSheetForPost(post: Post) {
        let alertController = UIAlertController(title: nil, message: "Do you want to flag this post?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Flag", style: .Destructive) { (action) in
            post.flagPost(PFUser.currentUser()!)
        }
        
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
    }
}

extension TimelineViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        let post = timelineComponent.content[indexPath.section]
        post.downloadImage()
        post.fetchLikes()
        cell.post = post
        cell.timeline = self
        
        return cell
    }
}

extension TimelineViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("PostHeader") as! PostSectionHeaderView
        
        let post = self.timelineComponent.content[section]
        headerCell.post = post
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

// MARK: Style

extension TimelineViewController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}



