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
        timelineComponent.loadInitialIfRequired()
        
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
    
    /*
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1
        //let followingQuery = PFQuery(className: "Follow")
        //followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        // 2
        //let postsFromFollowedUsers = Post.query()
        //postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        // 3
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        // 4
        //let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        // 5
        postsFromThisUser!.includeKey("user")
        // 6
        //query.orderByDescending("createdAt")
        
        // 7
        postsFromThisUser!.findObjectsInBackgroundWithBlock {(result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            
            // 1
            for post in self.posts {
                do {
                    // 2
                    let data = try post.imageFile?.getData()
                    // 3
                    post.image.value = UIImage(data: data!, scale:1.0)
                } catch {
                    print("could not get image")
                }
            }
            
            self.tableView.reloadData()
        }
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
                
                print(indexPath.row)
                // 2
                let newPost = posts[indexPath.row]
                // 3
                let displayNoteViewController = segue.destinationViewController as! imageCaptureViewController
                // 4
                displayNoteViewController.newPost = newPost
                
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
        
        // 2
        
        let post = timelineComponent.content[indexPath.section]
        post.downloadImage()
        cell.post = post
        cell.timeline = self
        cell.postImageView.image = post.image.value
        cell.petNameTextLabel.text = post.postTitle
        //posts[indexPath.row] = post
        //cell.postImageView.image = posts[indexPath.row].image.value
        //cell.petNameTextLabel.text = posts[indexPath.row].postTitle
        //cell.post = posts[indexPath.row]
        //cell.timeline = self
        
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

