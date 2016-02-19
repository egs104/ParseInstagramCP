//
//  HomeViewController.swift
//  ParseInstagramCP
//
//  Created by Eric Suarez on 2/16/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var captions = [String]()
    var users = [String]()
    var imageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        var getImagesQuery = PFQuery(className:"Post")
        getImagesQuery.includeKey("owningUserId")
        getImagesQuery.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            
            if let objects = objects {
                
                for object in objects {
                    
                    if object["caption"] != nil {
                        self.captions.append(object["caption"] as! (String))
                    } else {
                        self.captions.append(" ")
                    }
                    
                    self.imageFiles.append(object["imageFile"] as! (PFFile))
                    
                    self.users.append(object["owningUserId"].username!! as! String)
                    
                    //self.users.append(object["userId"].username!! as String)
                    
                    print(object["caption"])
                    print(object["owningUserId"].username!!)
                    
                    self.tableView.reloadData()
                }
                
            }
            
        }
        
        print(captions)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return imageFiles.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock{ (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.postImage.image = downloadedImage
                
            }
            
        }
        
        myCell.handle.text = users[indexPath.row]
        myCell.captionLabel.text = captions[indexPath.row]
        
        return myCell
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        
        self.performSegueWithIdentifier("logoutSegue", sender: self)
        
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
