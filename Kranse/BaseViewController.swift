//
//  BaseViewController.swift
//  Kranse
//
//  Created by macbook on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {
    var btnLeft: UIButton?
    var alertController : UIAlertController?
    var activityIndicator : UIActivityIndicatorView?
    var firstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    func showBackButton(text:String,black:Bool){
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.clearColor()
        btnLeft = UIButton(frame: CGRectMake(5,0,60,30))
        btnLeft?.setImage(UIImage.init(named: black ? "ic_back_black" : "ic_back"), forState: .Normal)
//        btnLeft?.setTitle("Back", forState: .Normal)
        btnLeft?.titleLabel?.font = UIFont(name: "OpenSans", size: 13)
        if text.characters.count > 0 {
            btnLeft?.setTitle(text, forState: .Normal)
            btnLeft?.setTitleColor(black ? UIColor.blackColor() : UIColor.whiteColor(), forState: .Normal)
        }
        btnLeft?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
        btnLeft?.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        btnLeft?.titleLabel?.text = text
        btnLeft?.addTarget(self, action: #selector(pressedBack(_:)), forControlEvents: .TouchUpInside)
        btnLeft?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        btnLeft?.imageEdgeInsets  = UIEdgeInsetsMake(7, -10, 7, 0)
        let itemLeft = UIBarButtonItem(customView: btnLeft!)
        self.navigationItem.leftBarButtonItem = itemLeft;
        
    }
    func setNavigatorBarTranslucent(isTransparent: Bool){
        if isTransparent {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: .Default)
    
        }else{
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.blackColor().colorWithAlphaComponent(0.5)), forBarMetrics: .Default)
        }
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
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
    func pressedBack(sender: UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    func backToController(vcClass: AnyClass?){
        let viewcontrollers = self.navigationController?.viewControllers
        for controller in viewcontrollers!{
            if controller .isKindOfClass(vcClass!) {
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
}
extension BaseViewController{
    func isConnectedToNetwork() ->Bool{
        return Reachability.isConnectedToNetwork()
    }
}
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image.CGImage else { return nil }
        self.init(CGImage: cgImage)
    }
}
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}