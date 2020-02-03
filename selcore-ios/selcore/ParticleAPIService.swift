//
//  ParticleAPIService.swift
//  selcore
//
//  Created by Rix on 4/26/15.
//  Copyright (c) 2015 bitcore. All rights reserved.
//

import Foundation

class ParticleAPIService
{
    
    //static api key for app
    let apiKey = "aD7WrqSxV8ur7C59Ig6gf72O5El0mz04"
    //user api authentication token
    let apiToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI1NjJmZDlkZjAxMjFjZGU4MjE0YmY1YTEiLCJ1c2VybmFtZSI6ImRyb3BhY2lkIiwicGFzc3dvcmQiOiIkMmEkMTAkdVByd3lvWW5xWjVWbkZUckZZS21iT2k2cVhWZjIyRHo3SXdiZG1PRE9vaDJwRm82VVNLQksiLCJlbWFpbCI6InJpeGVtcGlyZUBnbWFpbC5jb20iLCJfX3YiOjAsImNyZWF0ZWRPbiI6IjIwMTUtMTAtMjdUMjA6MDk6MDMuMDgxWiIsInF1YW50YSI6WyI1NjJmZjUwYjAxMjFjZGU4MjE0YmY1YTIiLCI1NjMwMmMyYjAxMjFjZGU4MjE0YmY1YWIiLCI1NjMwMmM1ZDAxMjFjZGU4MjE0YmY1YWMiLCI1NjMwMmM3ZjAxMjFjZGU4MjE0YmY1YWQiLCI1NjNiYjM4OTUxODYwNTlhMDA1ZmE1YjIiLCI1NjNiYjNjOTUxODYwNTlhMDA1ZmE1YjMiLCI1NjNiYjQ4NDUxODYwNTlhMDA1ZmE1YjQiLCI1NjNiYjUzNzFlMTliY2E0MDNmYTE1YWIiLCI1NjNiYmIwODFlMTliY2E0MDNmYTE1YWQiXX0.xIh3qescatTScSVIXdZ27_DBy0GUE7A2RG3zLbv7eXk"
    //base url for api
    let apiURL = "http://localhost:3000"
    
    //let apiURL = "http://192.168.25.185:3000"
    
    
    init(){}
    
    // MARK: - Particle API Calls
    
    //GET a list of partiles
    func getParticles(callback:(NSDictionary) -> ())
    {
        let url = "\(apiURL)/api/particle"
        
        get(url, callback: callback)
    }
    
    //GET a particle by id
    func getParticleByID(particleID:String, callback:(NSDictionary) -> ())
    {
        let url = "\(apiURL)/api/particle/\(particleID)"
        
        get(url, callback: callback)
    }
    
    //POST create a particle
    func createParticle(particle:Particle, callback:(Int, NSDictionary) -> ())
    {
        let url = "\(apiURL)/api/particle/"
        let postParam:NSString = "name=\(particle.name!)&description=\(particle.description!)&user_id=\(particle.userID!)&price=\(particle.price!)&alive=1"
        
        //println(url)
        post(url, postParam:postParam as String, callback: callback)
    }

    //PUT - update a particle by id
    func updateParticle(particle:Particle, callback:(Int, NSDictionary) -> ())
    {
        let url = "\(apiURL)/api/particle/\(particle.id)"
        let postParam:NSString = "name=\(particle.name)&description=\(particle.description)&user_id=\(particle.userID)&price=\(particle.price)&alive=1"
        
        //println(url)
        put(url, postParam:postParam as String, callback: callback)
    }
    
    
    // MARK: - User API Calls
    
    //POST create a user
    func createUser(user:User, callback:(Int, NSDictionary) -> ())
    {
        let url = "\(apiURL)/api/user/"
        let postParam:NSString = "username=\(user.username)&email=\(user.email)&password=\(user.password)"
        
        //println(url)
        post(url, postParam:postParam as String, callback: callback)
    }
    
    //POST create a user
    func loginUser(user:User, callback:(Int, NSDictionary) -> ())
    {
        let url = "\(apiURL)/api/login"
        let postParam:NSString = "username=\(user.username)&password=\(user.password)"
        
        //println(url)
        post(url, postParam:postParam as String, callback: callback)
    }

    
    // MARK: - Generic API Calls
    
    //Function call the new way
    //GET API Call
    func get(url:String, callback:(NSDictionary) -> ())
    {
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue(apiToken, forHTTPHeaderField: "x-access-token")

        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            (data,response,error) in
           // let error:NSError?
            let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!,options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary;

            print(jsonResult)

            callback(jsonResult)
        }
        task.resume()
    }
    
    //POST API Call
    func post(url:String, postParam:String,  callback:(Int, NSDictionary) -> ())
    {
        let postData:NSData = postParam.dataUsingEncoding(NSASCIIStringEncoding)!
        let postLength:NSString = String( postData.length)
            
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue(apiToken, forHTTPHeaderField: "x-access-token")

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            (data,response,error) in
            //let error:NSError?
            let responseData = (try! NSJSONSerialization.JSONObjectWithData(data!,options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
          
            //println("erorr \(response!.description)")
            if let httpResponse = response as? NSHTTPURLResponse
            {
               callback(httpResponse.statusCode, responseData)
            } else {
               callback(0, responseData)
            }
        }
        task.resume()
    }
    
    //PUT API Call
    func put(url:String, postParam:String,  callback:(Int, NSDictionary) -> ())
    {
        let postData:NSData = postParam.dataUsingEncoding(NSASCIIStringEncoding)!
        let postLength:NSString = String( postData.length)

        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "PUT"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue(apiToken, forHTTPHeaderField: "x-access-token")

//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
//            (data, response, error) -> Void in
//            do {
//                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
//                // use jsonData
//                print(jsonResult)
//                
//                callback(jsonResult)
//            } catch {
//                // report error
//            }
//        })
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            (data,response,error) in
            //let error:NSError?
            let responseData = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            //println("erorr \(response!.description)")
            if let httpResponse = response as? NSHTTPURLResponse
            {
                callback(httpResponse.statusCode, responseData)
            } else {
                callback(0, responseData)
            }
        }
        task.resume()
    }
    
    
    
    ////////////////////
    //old code delete
    //Memory GET API Call
    func request(url:String, callback:(NSDictionary) -> ())
    {
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue(apiToken, forHTTPHeaderField: "x-access-token")

        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            //var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)) as! NSDictionary
            
            print(jsonResult)
            
            callback(jsonResult)
        
        })
    }
    
}