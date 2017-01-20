//
//  WellcomeViewController.swift
//  Kranse
//
//  Created by macbook on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class WellcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        AppRuntime.sharedInstance.setFristTime()

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "registerSegue" {
            let webview = segue.destinationViewController as? KranseWebviewController
            webview?.addressType = AddressType.Register.rawValue
        }
    }
}