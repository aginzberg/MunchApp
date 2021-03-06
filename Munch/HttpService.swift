//
//  HttpService.swift
//  Munch
//
//  Created by Adam Ginzberg on 3/8/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import Foundation
import SwiftyJSON

class HttpService {
    

    private static let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    private static var dataTask: NSURLSessionDataTask?
    private static let Keychain = KeychainWrapper()
    
    private static func createStringFromDictionary(dict: Dictionary<String, String>) -> String {
        var params = String()
        var first = true
        for (key, value) in dict {
            if !first {
                params += "&"
            }
            params += key + "=" + value
            first = false
        }
        return params
    }
    
    //Data parameter should maybe be AnyObject -- will make changes when we start making those kinds of requests
    static func doRequest(url: String, method: String, data: Dictionary<String,String>?, flag: Bool, synchronous: Bool) -> (data: JSON?, status: Bool) {
        let fullURL = NSURL(string: "https://getstuft.herokuapp.com\(url)")
        //Fetch on login and store somewhere that we can access here
        let request = NSMutableURLRequest(URL: fullURL!)
        request.HTTPMethod = method
        if flag {
            let token = Keychain.myObjectForKey(kSecValueData)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if data != nil {
            request.HTTPBody = createStringFromDictionary(data!).dataUsingEncoding(NSUTF8StringEncoding)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        let semaphore = dispatch_semaphore_create(0)
        var responseData: JSON? = nil
        var status = false
        dataTask = defaultSession.dataTaskWithRequest(request) { data, response, error in
            if self.dataTask != nil {
                self.dataTask?.cancel()
            }
            if let error = error {
                print(error)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    responseData = JSON(data: data!)
                    status = true
                } else {
                    responseData = JSON(data: data!)
                }
            }
            dispatch_semaphore_signal(semaphore)
        }
        dataTask?.resume()
        if synchronous {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        }
        return (responseData, status)
    }
}