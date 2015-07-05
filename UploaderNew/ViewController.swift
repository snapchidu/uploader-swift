//
//  ViewController.swift
//  UploaderNew
//
//  Created by Alexander Handy on 01/07/2015.
//  Copyright (c) 2015 StitchVid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var linkField: UITextField!
    
    @IBOutlet weak var tagField: UITextField!
    
    @IBOutlet weak var MainImg: UIImageView!
    
    @IBAction func selectVid(sender: UIButton) {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        myPickerController.cameraCaptureMode = .Photo
//        myPickerController.allowsEditing = false
        //if try and do a camera mode it crashes in simulator
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
        
    {
        MainImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func sendUpload(sender: UIButton) {
        myImageUploadRequest()
    }

    //origin get and post requests below
//        let urlPath =
//        let url = NSURL(string: urlPath)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
//            println("Task completed")
//            if(error != nil) {
//                // If there is an error in the web request, print it to the console
//                println(error.localizedDescription)
//            }
//            var err: NSError?
//            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSArray {
//                println(jsonResult)
////                var dataOut = jsonResult as Dictionary<String,AnyObject>
////                println(dataOut)
//                //omitted some additional error handling code
//            }
//        })
//        task.resume()
//        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/videos")!)
//        request.HTTPMethod = "POST"
//        let postString = "link=" + linkField.text + "&all_tags=" + tagField.text
//        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil {
//                println("error=\(error)")
//                return
//            }
//            
//            println("response = \(response)")
//            
//            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("responseString = \(responseString)")
//        }
//        task.resume()
    
    func myImageUploadRequest() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/videos")!)
            request.HTTPMethod = "POST"
        
        let param = [
            "tag" : "Tester"
         ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(MainImg.image, 1)
        // how could you do this line without having to manually show the Image
        
        if(imageData==nil) { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            // You can print out response object
            println("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("****** response data = \(responseString!)")
            
            dispatch_async(dispatch_get_main_queue(),{
                self.MainImg.image = nil;
            });
        }
        task.resume()
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//

}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}


