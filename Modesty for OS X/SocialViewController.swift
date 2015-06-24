//
//  SocialViewController.swift
//  Modesty
//
//  Created by Joshua Barrow on 6/10/15.
//  Copyright © 2015 Jukaela Enterprises. All rights reserved.
//

import Cocoa

class SocialViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    let dataSource = ["Twitter", "Instagram", "Facebook", "Modesty Forums", "Planet Minecraft", "Minecraftservers.org", "Minecraft Servers List"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 6
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier("Social", owner: self) as! NSTableCellView
        cell.textField!.stringValue = dataSource[row]
        return cell;
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return dataSource[row]
    }

}
