//
//  ListParticlesTableViewController.swift
//  selcore
//
//  Created by Rix on 5/21/15.
//  Copyright (c) 2015 bitcore. All rights reserved.
//

import UIKit

class ListParticlesTableViewController: UITableViewController {

    var particlesCollection = [Particle]()
    var service = ParticleAPIService()
    var imageCache = [String:UIImage]()
    let apiURL = "http://localhost:3000/images/"
    var userDefaults:NSUserDefaults!
    //let apiURL = "http://192.168.25.185:3000/images/"
    
    @IBAction func AddParticleButton(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let token = defaults.stringForKey("token")
        {
            self.performSegueWithIdentifier("ListParticlesToCreateParticle", sender: self)
        } else {
            self.performSegueWithIdentifier("ListParticlesToLogin", sender: self)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadNewParticles()
        
        //create user default object
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        
        // self.tableView.contentInset = UIEdgeInsetsMake(0, -15, 0, 0);
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func loadNewParticles()
    {
        service.getParticles{
            (response) in
            //println(response["data"]! as! NSArray)
            
            if let particles = response["data"] as? NSArray {
                self.loadParticles(particles)
            }
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        
        }
    }

    func loadParticles(particles:NSArray){
        var error = false
   
        print(particles)
        
        for part in particles{
            if let p = part as? NSDictionary
            {
                if let particleObj = Particle(json: p){
                    particlesCollection.append(particleObj)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
//
//        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//            // #warning Potentially incomplete method implementation.
//            // Return the number of sections.
//            return 0
//        }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return particlesCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell: ListParticlesTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! ListParticlesTableViewCell

        // Configure the cell...
        let particle = particlesCollection[indexPath.row]
       
        cell.particleNameLabel!.text = particle.name
        cell.particleImage!.image = UIImage(named: "blank1")
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        if particle.images.count > 0 {
            let imageName = particle.images[0]
            let urlString = apiURL + imageName
            print("url string \(urlString)")
            if let imgURL = NSURL(string: urlString) {
            
                if let img = imageCache[urlString] {
                    cell.particleImage!.image = img
                } else {
                    // The image isn't cached, download the img data
                    // We should perform this in a background thread
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    let mainQueue = NSOperationQueue.mainQueue()
                    NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                            // Convert the downloaded data in to a UIImage object
                            let image = UIImage(data: data!)
                            // Store the image in to our cache
                            self.imageCache[urlString] = image
                            // Update the cell
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? ListParticlesTableViewCell{
                                    cellToUpdate.particleImage!.image = image
                                }
                            })
                        }
                        else {
                            print("Error: \(error!.localizedDescription)")
                        }
                    })
                }
            
            }
            
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
