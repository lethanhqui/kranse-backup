//
//  MyViewController.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    var alertController : UIAlertController?
    var activityIndicator : UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func showAlertWithMessage(message:String){
        alertController = UIAlertController.init(title: "", message:message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction =  UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {action in
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController?.addAction(okAction)
        self.presentViewController(alertController!, animated: true, completion: nil)
        
    }
    func showLoadingView(){
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator?.center = self.view.center
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.frame = self.view.bounds
        activityIndicator?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        self.view?.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    func hideLoadingView(){
        
        guard (activityIndicator != nil) else {return}
        activityIndicator?.stopAnimating()
        
    }
    
    func isConnectedToNetwork() ->Bool{
        return Reachability.isConnectedToNetwork()
    }
}

extension UINavigationController {
    func popViewControllerWithHandler(completion: ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewControllerAnimated(true)
        CATransaction.commit()
    }
    func pushViewController(viewController: UIViewController, completion: ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
}