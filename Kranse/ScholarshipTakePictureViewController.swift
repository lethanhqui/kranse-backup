//
//  ScholarshipTakePictureViewController.swift
//  Kranse
//
//  Created by macbook on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
import UIKit

class ScholarshipTakePictureViewController: BaseViewController {
//    var errorLabel = UILabel();
    var snapButton = UIButton();
    var switchButton = UIButton();
    var flashButton = UIButton()
//    var settingsButton = UIButton();
//    var segmentedControl = UISegmentedControl();
    var camera = LLSimpleCamera();
    var previewImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.camera.start();
    }
    
    func initViews(){
        initCamera()
        showBackButton("Back",black: false)
        setNavigatorBarTranslucent(true)
    }
    func initCamera(){
        let screenRect = UIScreen.mainScreen().bounds;
        
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        self.camera.attachToViewController(self, withFrame: CGRectMake(0, 0, screenRect.size.width, screenRect.size.height))
        self.camera.fixOrientationAfterCapture = true;
        
        
        self.camera.onDeviceChange = {(camera, device) -> Void in
            if camera.isFlashAvailable() {
                self.flashButton.hidden = false
                if camera.flash == LLCameraFlashOff {
                    self.flashButton.selected = false
                }
                else {
                    self.flashButton.selected = true
                }
            }
            else {
                self.flashButton.hidden = true
            }
        }
        
        self.camera.onError = {(camera, error) -> Void in
            if (error.domain == LLSimpleCameraErrorDomain) {
                if error.code == 10 || error.code == 11 {
//                    if(self.view.subviews.contains(self.errorLabel)){
//                        self.errorLabel.removeFromSuperview()
//                    }
//                    
//                    let label: UILabel = UILabel(frame: CGRectZero)
//                    label.text = "We need permission for the camera and microphone."
//                    label.numberOfLines = 2
//                    label.lineBreakMode = .ByWordWrapping;
//                    label.backgroundColor = UIColor.clearColor()
//                    label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
//                    label.textColor = UIColor.whiteColor()
//                    label.textAlignment = .Center
//                    label.sizeToFit()
//                    label.center = CGPointMake(screenRect.size.width / 2.0, screenRect.size.height / 2.0)
//                    self.errorLabel = label
//                    self.view!.addSubview(self.errorLabel)
                    
//                    let jumpSettingsBtn: UIButton = UIButton(frame: CGRectMake(50, label.frame.origin.y + 50, screenRect.size.width - 100, 50));
//                    jumpSettingsBtn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 24.0)
//                    jumpSettingsBtn.setTitle("Go Settings", forState: .Normal);
//                    jumpSettingsBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal);
//                    jumpSettingsBtn.layer.borderColor = UIColor.whiteColor().CGColor;
//                    jumpSettingsBtn.layer.cornerRadius = 5;
//                    jumpSettingsBtn.layer.borderWidth = 2;
//                    jumpSettingsBtn.clipsToBounds = true;
//                    jumpSettingsBtn.addTarget(self, action: #selector(ScholarshipTakePictureViewController.jumpSettinsButtonPressed(_:)), forControlEvents: .TouchUpInside);
//                    jumpSettingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//                    
//                    self.settingsButton = jumpSettingsBtn;
//                    
//                    self.view!.addSubview(self.settingsButton);
                    
                    self.switchButton.enabled = false;
                    self.flashButton.enabled = false;
                    self.snapButton.enabled = false;
                }
            }
        }
        
        if(LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable()){
            let bottomPanelView = UIView(frame: CGRectMake(0,CGRectGetHeight(UIScreen.mainScreen().bounds) - 100, self.view.frame.size.width,100))
            bottomPanelView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            self.view!.addSubview(bottomPanelView)
                
            self.snapButton = UIButton(type: .Custom)
            self.snapButton.frame = CGRectMake(0, 0, 70.0, 70.0)
//            self.snapButton.clipsToBounds = true
//            self.snapButton.layer.cornerRadius = self.snapButton.frame.width / 2.0
//            self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
//            self.snapButton.layer.borderWidth = 3.0
//            self.snapButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6);
//            self.snapButton.layer.rasterizationScale = UIScreen.mainScreen().scale
//            self.snapButton.layer.shouldRasterize = true
            self.snapButton.setImage(UIImage(named: "ic_take_photo"), forState: .Normal)
            self.snapButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            self.snapButton.addTarget(self, action: #selector(ScholarshipTakePictureViewController.snapButtonPressed(_:)), forControlEvents: .TouchUpInside)
            self.view!.addSubview(self.snapButton)
            
            self.flashButton = UIButton(type: .System)
            self.flashButton.frame = CGRectMake(0, 0, 16.0 + 20.0, 24.0 + 20.0)
            self.flashButton.tintColor = UIColor.whiteColor()
            self.flashButton.setImage(UIImage(named: "camera-flash.png"), forState: .Normal)
            self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            self.flashButton.addTarget(self, action: #selector(ScholarshipTakePictureViewController.flashButtonPressed(_:)), forControlEvents: .TouchUpInside)
            self.flashButton.hidden = true;
            self.view!.addSubview(self.flashButton)
            
            self.switchButton = UIButton(type: .System)
            self.switchButton.frame = CGRectMake(0, 0, 29.0 + 20.0, 22.0 + 20.0)
            self.switchButton.tintColor = UIColor.whiteColor()
            self.switchButton.setImage(UIImage(named: "camera-switch"), forState: .Normal)
            self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            self.switchButton.addTarget(self, action: #selector(ScholarshipTakePictureViewController.switchButtonPressed(_:)), forControlEvents: .TouchUpInside)
            let itemRight = UIBarButtonItem(customView: self.switchButton)
            self.navigationItem.rightBarButtonItem = itemRight
            

        }
        else{
//            let label: UILabel = UILabel(frame: CGRectZero)
//            label.text = "You must have a camera to take video."
//            label.numberOfLines = 2
//            label.lineBreakMode = .ByWordWrapping;
//            label.backgroundColor = UIColor.clearColor()
//            label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
//            label.textColor = UIColor.whiteColor()
//            label.textAlignment = .Center
//            label.sizeToFit()
//            label.center = CGPointMake(screenRect.size.width / 2.0, screenRect.size.height / 2.0)
//            self.errorLabel = label
//            self.view!.addSubview(self.errorLabel)
        }
    }
    
    func segmentedControlValueChanged(control: UISegmentedControl) {
        print("Segment value changed!")
    }
    
    func cancelButtonPressed(button: UIButton) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func jumpSettinsButtonPressed(button: UIButton){
        UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!);
    }
    
    func switchButtonPressed(button: UIButton) {
        if(camera.position == LLCameraPositionRear){
            self.flashButton.hidden = false;
        }
        else{
            self.flashButton.hidden = true;
        }
        
        self.camera.togglePosition()
    }
    
    func snapButtonPressed(button: UIButton) {
            // capture
            self.camera.capture({(camera, image, metadata, error) -> Void in
                if (error == nil) {
                    camera.performSelector(#selector(camera.stop), withObject: nil, afterDelay: 0.2)
//                    let storyboard = UIStoryboard.init(name: "Guide", bundle: nil)
//                    let imageVC: ScholarshipPreviewPicViewController = sto
//                    self.presentViewController(imageVC, animated: false, completion: { _ in })
                    self.previewImage = image;
                    self.performSegueWithIdentifier("previewPicSegue", sender: self)

                }
                else {
                    print("An error has occured: %@", error)
                }
                }, exactSeenImage: true)
        
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.camera.view.frame = self.view.bounds
        self.snapButton.center = self.view.center
        self.snapButton.frame.origin.y = self.view.bounds.height - 80
        self.flashButton.center = self.view.center
        self.flashButton.frame.origin.y = 5.0
        self.switchButton.frame.origin.y = 5.0
        self.switchButton.frame.origin.x = self.view.frame.width - 60.0
    }
    
    func flashButtonPressed(button: UIButton) {
        if self.camera.flash == LLCameraFlashOff {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOn)
            if done {
                self.flashButton.selected = true
                self.flashButton.tintColor = UIColor.yellowColor();
            }
        }
        else {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOff)
            if done {
                self.flashButton.selected = false
                self.flashButton.tintColor = UIColor.whiteColor();
            }
        }
    }
    
    func applicationDocumentsDirectory()-> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "previewPicSegue" {
            guard let previewVC = segue.destinationViewController as? ScholarshipPreviewPicViewController else {return}
            previewVC.previewImage = self.previewImage
            
        }
    }
}