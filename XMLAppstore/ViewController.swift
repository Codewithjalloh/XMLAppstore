//
//  ViewController.swift
//  XMLAppstore
//
//  Created by Jalloh on 27/06/2016.
//  Copyright © 2016 CodeWithJalloh. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, NSURLConnectionDataDelegate, NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, ImagesOperationDelegate {
    
    @IBOutlet weak var myTable: UITableView!
    var listData: NSMutableData!
    var currentString: NSMutableString!
    var shouldParse:Bool!
    var apps: NSMutableArray!
    var currentApp:AppInfo!

    override func viewDidLoad() {
        super.viewDidLoad()

        var queue = NSOperationQueue()
        let urlRequest = NSURLRequest(URL: NSURL(string: "http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml")!)
        
        NSURLConnection(request: urlRequest, delegate: self)
        currentString = NSMutableString(string: "")
        apps = NSMutableArray()
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        listData = NSMutableData()
        print("did receive response")
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        listData.appendData(data)
        print("did receive data")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        print("did finish loading")
        let parser = NSXMLParser(data: listData)
        parser.delegate = self
        parser.parse()
        myTable.reloadData()
        
        let queue = NSOperationQueue()
        for it in apps {
            let imagesOperation = imagesOperation()
            
        }
    }

    


}

