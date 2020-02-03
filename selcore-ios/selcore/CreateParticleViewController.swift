//
//  CreateParticleViewController
//  selcore
//
//  Created by Rix on 5/10/15.
//  Copyright (c) 2015 bitcore. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateParticleViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var beenHereBefore = false
    var controller: UIImagePickerController?
    var image:UIImage?
    var service = ParticleAPIService()
    var userDefaults:NSUserDefaults!
    
    @IBOutlet weak var particleImageView: UIImageView!
    @IBOutlet weak var particleNameTextField: UITextField!
    @IBOutlet weak var particleDescriptionTextView: UITextView!
    @IBOutlet weak var particlePriceTextField: UITextField!

    //static api key for app
    let apiKey = "aD7WrqSxV8ur7C59Ig6gf72O5El0mz04"
    //user api authentication token
    let apiToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI1NTQyYzk4MmJiNmM2MGUyM2EwNGU5NTciLCJlbWFpbCI6ImRyb3BhY2lkQGdtYWlsLmNvbSIsInBhc3N3b3JkIjoiJDJhJDEwJHJoY0dVSVdUbkFMVVRqTmV0Z05BTWUyYzd3TEI5ZDB3ZEdCeFpVVmpVdkpSVkZJN0draWJPIiwidXNlcm5hbWUiOiJkcm9wYWNpZCIsIl9fdiI6MCwiY3JlYXRlZE9uIjoiMjAxNS0wNS0wMVQwMDozMjowMi4yMjVaIiwicmF0aW5nIjowLCJudW1iZXJUcmFuc2FjdGlvbnMiOjAsImZlZWRiYWNrIjpbXSwicGFydGljbGVzIjpbXX0.DJD_dJS0HC_LZXoIb1HbAyTbl2fA9rxKYiu46Oyx-kU"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.particleImageView.image = UIImage(named: "pump")
        
        
        
        //create user default object
       
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let token = userDefaults.stringForKey("token")
        {
            // LoginToCreateParticle
            //self.performSegueWithIdentifier("CreateParticleToLogin", sender: self)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        if beenHereBefore{
            self.particleImageView.image = image
            return;
        } else {
            beenHereBefore = true
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func submitParticleButton(sender: UIButton) {
            
        let particle = Particle(id: "0", name: self.particleNameTextField.text!, description: self.particleDescriptionTextView.text, price: (self.particleDescriptionTextView.text as NSString).doubleValue, userID: "55395bfb37d12a5332dd4f99", username: "jeff", createdOn: "12/01/2015")
           // println(particle)
       // var particle = Particle(id: "553943da1197c6ec096a27df", name: "Computer 2", description: "this is the coolest comptuer2", price: 23.42, userID: "553943da1197c6ec096a27df", username: "jeff", createdOn: "12/01/2015")
            
        service.createParticle(particle){(response: Int, data:NSDictionary) in
            print(response)
            
            dispatch_async(dispatch_get_main_queue()) {
                if let feed = data["data"] as? NSDictionary {
                    if let particleID = feed["_id"] as? String {
                        print(particleID)
                        self.myImageUploadRequest(particleID);
                    }
                    
                }
            }
        }
    }
    
    @IBAction func addPhoto(sender: UIButton) { 
        if isCameraAvailable() && doesCameraSupportTakingPhotos(){
            controller = UIImagePickerController()
            
            if let theController = controller{
                theController.sourceType = .Camera
                //theController.sourceType = .PhotoLibrary
                
                //theController.mediaTypes = [kUTTypeImage as NSString]
                
                theController.allowsEditing = false
                theController.delegate = self
                
                presentViewController(theController, animated: true, completion: nil)
            }
        } else {
            noCamera()
        }
    }
    
    // MARK: - Image Picker Controller
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Picker return successfully")
        
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
        
        if let type:AnyObject = mediaType{
            if type is String{
                let stringType = type as! String
            
                if stringType == kUTTypeImage as NSString as NSString{
                    let metadata = info[UIImagePickerControllerMediaMetadata] as? NSDictionary
                    
                    if let theMetaData = metadata{
                        image = info[UIImagePickerControllerOriginalImage] as? UIImage
                
                        if let theImage = image{
                            print("image metadata = \(theMetaData)")
                            print("Image = \(theImage)")
                        }
                    }
                }
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Picker was cancelled")
        picker.dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    
    // MARK: - Camera Functions
    
    func cameraSupportsMedia(mediaType: String, sourceType: UIImagePickerControllerSourceType) -> Bool{
        let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType) as [String]?
        
        for type in availableMediaTypes!{
        if type == mediaType{
            return true
        }
        }
        return false
    }
    
    func doesCameraSupportShootingVideos() -> Bool{
        return cameraSupportsMedia(kUTTypeMovie as NSString as String, sourceType: .Camera)
    }
    
    func doesCameraSupportTakingPhotos() -> Bool{
        return cameraSupportsMedia(kUTTypeImage as NSString as String, sourceType: .Camera)
    }
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }

    
    
    // MARK: - Image upload Functions

    func myImageUploadRequest(particleID: String)
    {
        let data :NSData = UIImageJPEGRepresentation(self.particleImageView.image!, 100.0)!
        let boundary = "Boundary-\(NSUUID().UUIDString)"
       // let url = NSURL(string: APIURLs.uploadWorkerImage.stringByAppendingString(workerId))
          
        let url = NSURL(string: "http://192.168.25.185:3000/api/particle/upload/\(particleID)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue(apiToken, forHTTPHeaderField: "x-access-token")

        
        let body = NSMutableData()
        let key = "id"
        let value = "3asdfawef"
        body.appendData(NSString(string: "--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(string: "\(value)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
         
        let filename = "fileName.jpeg"
        let mimetype = "image/jpeg"
        
        body.appendData(NSString(string: "--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(string: "Content-Disposition: form-data; name=\"photo\"; filename=\"\(filename)\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(string: "Content-Type: \(mimetype)\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(data)
        body.appendData(NSString(string: "\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(NSString(string: "--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
                        
        
//        let myUrl = NSURL(string: "http://localhost:3000/upload")
//            let request = NSMutableURLRequest(URL:myUrl!)
//            request.HTTPMethod = "POST"
//        
//        let param = [
//        "name" :  "helo",
//        "lastName" : "Kargopolov",
//        "userId" : "9"
//        ]
//        
//        let boundary = generateBoundaryString()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        let imageData =  UIImageJPEGRepresentation(self.particleImageView.image, 1)
//        if(imageData==nil) { return; }
//        
//        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
//        
//        //myActivityIndicator.startAnimating()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            
            dispatch_async(dispatch_get_main_queue(),{
    
                self.performSegueWithIdentifier("CreateParticleToAddPhoto", sender: self)

            });
            
        }
        
        task.resume()
        
    }

    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
                
        let body = NSMutableData();
        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("–\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("–\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("–\(boundary)–\r\n")
        
        
                
        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
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


extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

