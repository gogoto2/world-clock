//
//  InterfaceController.swift
//  watch-app Extension
//
//  Created by Thiago Peres on 25/02/16.
//  Copyright © 2016 peres. All rights reserved.
//

import WatchKit
import Foundation
import WorldClockWatch

class InterfaceController: WKInterfaceController {

    @IBOutlet var interfaceMap: WKInterfaceMap!
    @IBOutlet var timeAndCityLabel: WKInterfaceLabel!
    @IBOutlet var countryLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let city = WCController.random420City()
        
        // Configure interface objects here.
        timeAndCityLabel.setText(String(format:"%@ in %@", city.currentTimeString, city.name))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
