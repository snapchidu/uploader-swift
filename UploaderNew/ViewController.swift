//
//  ViewController.swift
//  UploaderNew
//
//  Created by Alexander Handy on 01/07/2015.
//  Copyright (c) 2015 StitchVid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var linkField: UITextField!
    
    @IBOutlet weak var tagField: UITextField!
    
    @IBAction func sendUpload(sender: UIButton) {
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
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/videos")!)
        request.HTTPMethod = "POST"
        let postString = "link=" + linkField.text + "&all_tags=" + tagField.text
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

