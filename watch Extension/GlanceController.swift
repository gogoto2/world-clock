//
//  GlanceController.swift
//  watch Extension
//
//  Created by Thiago Peres on 26/02/16.
//  Copyright © 2016 peres. All rights reserved.
//

import WatchKit
import Foundation
import WorldClockWatch

class GlanceController: WKInterfaceController {

    @IBOutlet var hourLabel: WKInterfaceLabel!
    @IBOutlet var cityLabel: WKInterfaceLabel!
    @IBOutlet var countryLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Configure interface objects here.
        let city = WCController.random420City()
        
        hourLabel.setText(city.currentTimeString)
        cityLabel.setText(city.name)
        countryLabel.setText(city.countryCode)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
