//
//  PostIndexViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 15/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit
import ConvenienceKit
import Parse

class PostIndexViewController: UIViewController, TimelineComponentTarget {
    
    @IBOutlet weak var tableView: UITableView!
    
    var timelineComponent: TimelineComponent <Post, PostIndexViewController>!
    
    @IBAction func unwindToPostIndex(segue: UIStoryboardSegue) {}
    
    var posts = [Post]() {
        didSet{
            print("something got deleted reloading table")
            tableView.reloadData()
        }
    }
    
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        timelineComponent = TimelineComponent(target: self)
        timelineComponent.refresh(posts)
        timelineComponent.loadInitialIfRequired()
        
        //
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
    }
    
    
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
        ParseHelper.timelineRequestForCurrentUser(range) {
            (result: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            
            self.posts = result as? [Post] ?? []
            completionBlock(self.posts)
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /*
     override func viewWillDisappear(animated: Bool) {
     super.viewWillDisappear(animated)
     
     navigationController?.setNavigationBarHidden(false, animated: false)
     } */
    
    // MARK: UIActionSheets
    
    func showActionSheetForPost(post: Post) {
        if (post.user!.objectId! == PFUser.currentUser()!.objectId!) {
            print("calling showActionSheetForPost")
            showDeleteActionSheetForPost(post)
        } else {
            print("user test is false")
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "editPostImage" {
                print("Table view cell tapped")
                
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                
                print(indexPath.section)
                // 2
                let newPost = posts[indexPath.section]
                // 3
                let destVC = segue.destinationViewController as! imageCaptureViewController
                // 4
                destVC.newPost = newPost
                
            }
        }
    }
    
    
}


extension PostIndexViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 1
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        //
            cell.layoutMargins = UIEdgeInsetsZero
        
        // 2
        
        let post = timelineComponent.content[indexPath.section]
        post.downloadImage()
        cell.post = post
        cell.timeline = self
        cell.postImageView.image = post.image.value
        cell.petNameTextLabel.text = post.postTitle?.uppercaseString
        //posts[indexPath.row] = post
        //cell.postImageView.image = posts[indexPath.row].image.value
        //cell.petNameTextLabel.text = posts[indexPath.row].postTitle
        //cell.post = posts[indexPath.row]
        //cell.timeline = self
        
        /*
        cell.postImageView.layer.masksToBounds = true
        cell.postImageView.layer.borderWidth = 10
        cell.postImageView.layer.borderColor = UIColor.whiteColor().CGColor
        */ 
        
        return cell
        
        /*let post = posts[indexPath.row]
         // 1
         post.downloadImage()
         // 2
         cell.post = post
         
         return cell*/
    }
}


extension PostIndexViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.section)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

