//
//  DeviceService.swift
//  Kranse
//
//  Created by macbook on 9/21/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
import UIKit
class DeviceService: NSObject {
    static func getAppVersion()->String{
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        return version;
    }
    static func getIOSVersion()->String{
        let  systemVersion = UIDevice.currentDevice().systemVersion
        return systemVersion;
    }
    static func getUDID()->String{
        //        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
}