//
//  UserInfoViewController.swift
//  Scruffy
//
//  Created by Veronica Tan on 15/7/16.
//  Copyright © 2016 Veronica Tan. All rights reserved.
//

import UIKit
import Static

class UserInfoViewController: UIViewController {
    
    @IBAction func unwindToUserInfo(segue: UIStoryboardSegue) {}
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        dataSource.tableView = tableView
        dataSource.sections = [
            Section(
                header: Section.Extremity.Title("Details"),
                rows: [
                    Row(text: "User Profile", selection: { [unowned self] in
                        let viewController = petNameViewController()
                        self.navigationController?.pushViewController(viewController, animated: true)
                        })
                ]
            ),
]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
}
