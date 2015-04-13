//
//  ViewPlayerInterfaceController.swift
//  Modesty
//
//  Created by Joshua Barrow on 4/13/15.
//  Copyright (c) 2015 Jukaela Enterprises. All rights reserved.
//

import WatchKit
import Foundation

class ViewPlayerInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var playerImage: WKInterfaceImage!
    @IBOutlet weak var playerNameLabel: WKInterfaceLabel!
    @IBOutlet weak var rankLabel: WKInterfaceLabel!

    var playerNameString: String!
    
    init(context: AnyObject?) {
        super.init()
        
        if let p = context as? String {
            self.playerNameString = p
            self.playerNameLabel.setText(p)
            
            loadPlayerImage()
            loadStaffData()
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func loadPlayerImage() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let url = NSURL(string: String(format: "https://minotar.net/helm/%@/200.png", self.playerNameString))
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.playerImage.setImage(image)
            }
        }
    }
    
    func checkRank() {
        var staffArray:[String]
        
    }
    
    func loadStaffData() {
        let url = NSURL(string:"http://safe-retreat-6833.herokuapp.com/users.json")
        let request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let staffArray = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: nil) as? NSArray
            
            if let staffListing = staffArray {
                for array: NSArray in staffListing as! [NSArray] {
                    for dict: NSDictionary in array as! [NSDictionary] {
                        if dict["username"] as! String == self.playerNameString {
                            self.rankLabel.setText(dict["rank"] as? String)
                        }
                    }
                }
            }
        })
    }
    /*
-(void)mapToStaff:(NSArray *)staffArray
{
NSMutableArray *tempStaffArray = [NSMutableArray array];

for (NSArray *array in staffArray) {
for (NSDictionary *dict in array) {
Staff *staffMember = [[Staff alloc] init];

[staffMember setStaffId:dict[@"id"]];
[staffMember setUsername:dict[@"username"]];
[staffMember setRank:dict[@"rank"]];
[staffMember setUrl:dict[@"url"]];

[tempStaffArray addObject:staffMember];
}
}

[self setStaff:tempStaffArray];
}
*/
    
}