//
//  PetsInfoViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 15/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {
  
    @IBOutlet weak var petImageThumbnail: UIImageView!
    @IBOutlet weak var petDescTextLabel: UITextView!

    @IBOutlet weak var petNameTextLabel: UILabel!
 
    @IBOutlet weak var contactHeaderTextLabel: UILabel!
    
    @IBOutlet weak var contactDetailsTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
