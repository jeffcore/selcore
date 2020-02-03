//
//  MainMenuViewController.swift
//  selcore
//
//  Created by Rix on 4/28/15.
//  Copyright (c) 2015 bitcore. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var particlesCollection = [Particle]()
    var service = ParticleAPIService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        let particle = Particle(id: "5541b080ae18b1052662e7cf", name: "Computer 2", description: "this is the coolest comptuer2", price: 23.42, userID: "55395bfb37d12a5332dd4f99", username: "jeff", createdOn: "12/01/2015")
      
        var user = User(id: "0", username: "dropacid", email: "dropacid@gmail.com", password: "553399", numberTransactions: 0, rating: 0, createdOn: "12-25-2015")
        
        //self.loadNewParticles()
        //self.loadParticle(particle.id)
        

//USER
//        service.loginUser(user){
//            (response: Int, data:NSDictionary) in
//            println(data)
//            println(response)
//            
//            dispatch_async(dispatch_get_main_queue())
//            {
//                var addAlert = UIAlertView(title: "User Added", message: "Successfully Added To Brain", delegate: self, cancelButtonTitle: "OK")
//                addAlert.show()
//            }
//        }
//
      
        
        
//PARTICLE
        service.createParticle(particle){(response: Int, data:NSDictionary) in
            print(response)
            
            dispatch_async(dispatch_get_main_queue())
                {
                    let addAlert = UIAlertView(title: "Memory Add", message: "Successfully Added To Brain", delegate: self, cancelButtonTitle: "OK")
                    addAlert.show()
            }
        }
        
        
//        service.updateParticle(particle){
//            (response: Int, data: NSDictionary) in
//              println(data)
//              println(response)
//
//            dispatch_async(dispatch_get_main_queue())
//            {
//                    var addAlert = UIAlertView(title: "Memory Add", message: "Successfully Added To Brain", delegate: self, cancelButtonTitle: "OK")
//                    addAlert.show()
//            }
//        }
        
//USER
//        service.createUser(user){(response: Int) in
//            println(response)
//
//            dispatch_async(dispatch_get_main_queue())
//            {
//                    var addAlert = UIAlertView(title: "User Added", message: "Successfully Added To Brain", delegate: self, cancelButtonTitle: "OK")
//                    addAlert.show()
//            }
//        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadNewParticles()
    {
        service.getParticles
        {
            (response) in
            print(response["data"]! as! NSArray)
            //println("tableview response")
        }
    }

    
    func loadParticle(particleID:String)
    {
        service.getParticleByID(particleID)
        {
            (response) in
            print(response["data"]! as! NSArray)
            //println("tableview response")
        }
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