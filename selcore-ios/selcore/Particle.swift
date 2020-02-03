//
//  Particle.swift
//  selcore
//
//  Created by Rix on 4/26/15.
//  Copyright (c) 2015 bitcore. All rights reserved.
//

import Foundation

class Particle {
    
    var id:String?
    var name:String?
    var description:String?
    var price:Double?
    var userID:String?
    var username:String?
    var createdOn:String?
    var images = [String]()
    
    init(id:String, name:String, description:String, price:Double, userID:String, username:String, createdOn:String){
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.userID = userID
        self.username = username
        self.createdOn = createdOn
    }
    
    init?(json: NSDictionary){
        if let j_id = json["_id"] as? String {
            self.id = j_id
        } else {
            return nil
        }
        if let j_name = json["name"] as? String {
            self.name = j_name
        } else {
            return nil
        }
        if let j_desciption = json["description"] as? String {
            self.description = j_desciption
        }
        if let j_price = json["price"] as? Double {
            self.price = j_price
        }
        if let j_user = json["userID"] as? NSDictionary{
            if let j_userid = j_user["_id"] as? String{
                self.userID = j_userid
            }
            if let j_username = j_user["username"] as? String {
                self.username = j_username
            }
        }
        if let j_images = json["images"] as? NSArray {
            for image in j_images {
                images.append(image as! String)
            }
        }
        if let j_createdOn = json["createdOn"] as? String {
            self.createdOn = j_createdOn
        }
    }

}