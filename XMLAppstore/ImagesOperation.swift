//
//  ImagesOperation.swift
//  XMLAppstore
//
//  Created by Jalloh on 27/06/2016.
//  Copyright © 2016 CodeWithJalloh. All rights reserved.
//

import UIKit
import Foundation


protocol ImagesOperationDelegate {
    func imageOperation(imagesOperation:ImagesOperation, app: AppInfo)

}

class ImagesOperation: NSOperation, NSURLConnectionDelegate {
    
    var delegate: ImagesOperationDelegate?
    var app: AppInfo!
    var currentData: NSMutableData!
    
    
    override func main() {
        let connection = NSURLConnection(request: NSURLRequest(URL: NSURL(string: app.urlImage)!), delegate: self, startImmediately: false)
        connection!.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        connection!.start()
        self.currentData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.currentData = nil
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData) {
        self.currentData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        let image: UIImage? = UIImage(data: self.currentData)
        if(image != nil) {
            self.app.image = image
            self.delegate?.imageOperation(self, app: self.app)
        }
    }
    
    
    

}
