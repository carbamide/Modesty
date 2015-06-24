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
    @IBOutlet weak var loadingFullSizeLabel: WKInterfaceLabel!
    @IBOutlet weak var containerGroup: WKInterfaceGroup!
    
    var playerNameString: String!
    
    init(context: AnyObject?) {
        super.init()
        
        if let player = context as? String {
            self.playerNameString = player
            self.playerNameLabel.setText(player)
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    override func willActivate() {
        super.willActivate()
        
        setTitle(self.playerNameString)
        
        loadPlayerImage()
        
        self.rankLabel.setText(DataManager.sharedInstance.rankForUsername(self.playerNameString))
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func loadPlayerImage() {
        self.playerImage.setAccessibilityHint(String(format:"Avatar for %@", self.playerNameString))
        
            DataManager.sharedInstance.loadFullSizeImageForPlayer(self.playerNameString, completion: {
                imageData in
                dispatch_async(dispatch_get_main_queue()) {
                    self.finishedLoading()
                    self.playerImage.setImageData(imageData)
                }
            })
    }
    
    private func finishedLoading() {
        self.containerGroup.setHidden(false)
        self.loadingFullSizeLabel.setHidden(true)
    }
}