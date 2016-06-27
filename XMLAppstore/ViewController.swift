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
            let imagesOperation = ImagesOperation()
            imagesOperation.app = it as! AppInfo
            imagesOperation.delegate = self
            queue.addOperation(imagesOperation)
            
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let elementToParse = NSArray(objects: "id", "im:name", "im:image")
        
        if (elementName == "entry") {
            self.currentApp = AppInfo()
        }
        shouldParse = elementToParse.containsObject(elementName)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(self.currentApp != nil){
            let trimmedString = currentString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            currentString.setString("")
            if(elementName == "id") {
                self.currentApp.urlApp = trimmedString
                print("URL APP: \(trimmedString)")
            } else if(elementName == "im:name"){
                self.currentApp.name = trimmedString
                print("NAME: \(trimmedString)")
            } else if(elementName == "im:image") {
                self.currentApp.urlImage = trimmedString
                print("URL IMAGE \(trimmedString)")
            } else if(elementName == "entry") {
                self.currentApp.index = apps.count
                apps.addObject(currentApp)
                currentApp = nil
            }
            
        }
    }

    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if((shouldParse) != nil) {
            currentString.appendString(string)
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableHeaderFooterViewWithIdentifier("cell")
        let label: UILabel = cell?.viewWithTag(1111) as! UILabel
        let app = apps.objectAtIndex(indexPath.row) as! AppInfo
        label.text = app.name
        let imageView = cell?.viewWithTag(2222) as! UIImageView
        imageView.image = app.image
        
        return cell
        
        
    }
    
    

    
    
    func imagesOperation(imagesOperation:ImagesOperation, app: AppInfo) {
        var visibleCells = myTable.visibleCells
        let firstIndex = myTable.indexPathForCell(visibleCells[0] )?.row
        let lastIndex = myTable.indexPathForCell(visibleCells.last! as UITableViewCell)!.row
        if(app.index >= firstIndex && app.index <= lastIndex) {
            let cell = myTable.cellForRowAtIndexPath(NSIndexPath(forRow: app.index, inSection: 0))
            let imageView = cell?.viewWithTag(1987) as! UIImageView
            imageView.image = app.image
        }
        
    }

}

