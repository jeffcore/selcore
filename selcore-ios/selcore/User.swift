//
//  User.swift
//  selcore
//
//  Created by Rix on 4/30/15.
//  Copyright (c) 2015 bitcore. All rights reserved.
//

import Foundation

class User {
    
    var id:String
    var username:String
    var email:String
    var password:String
    var numberTransactions:Int
    var rating:Double
    var createdOn:String
    
    init(id:String, username:String, email:String, password:String, numberTransactions:Int, rating:Double, createdOn:String){
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.numberTransactions = numberTransactions
        self.rating = rating
        self.createdOn = createdOn
    }
    
}