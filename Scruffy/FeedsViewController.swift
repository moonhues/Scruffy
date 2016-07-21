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


class FeedsViewController: UIViewController {
    
    // MARK: Properties
    
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    
    var swipeLeftHandler: UISwipeGestureRecognizer?
    var swipeRightHandler: UISwipeGestureRecognizer?
    
    //var arrayOfPets: [NSDictionary] = []
    
    var arrayOfPets: [Post] = []
    
    var currentPosition: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // view.addSubview(<#T##view: UIView##UIView#>)
    
        
        /*
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
        */
 
        let allPostsQuery = Post.query()
        allPostsQuery?.findObjectsInBackgroundWithBlock
            {(result: [PFObject]?, error: NSError?) -> Void in
            // 8
            self.arrayOfPets = result as? [Post] ?? []
            // 9
            print(self.arrayOfPets[self.currentPosition].postTitle)
                self.petNameLabel.text = self.arrayOfPets[self.currentPosition].postTitle
                self.arrayOfPets[self.currentPosition].downloadImage()
                self.petImageView.image = self.arrayOfPets[self.currentPosition].image.value
                print(self.petNameLabel.text)
        }
        
        //petImageView.image = arrayOfPets[currentPosition].
       
        
        //post.fetchLikes()
        
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
                //let pet = arrayOfPets[currentPosition]
                reloadView()
            }
        }
        
        if gesture == swipeRightHandler {
            
            print("swiped right")
            
            //goes backward
            if currentPosition > 0 {
                currentPosition = currentPosition - 1
                
                //let pet = arrayOfPets[currentPosition]
                reloadView()
            }
        }
    }
    
    func reloadView() {
        
        print("currentposition: \(currentPosition)")
        
       arrayOfPets[currentPosition].downloadImage()
        petNameLabel.text = arrayOfPets[currentPosition].postTitle
        petImageView.image = arrayOfPets[currentPosition].image.value
    }
    
    
}





