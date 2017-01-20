//
//  VideoRecordScreen.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class VideoRecordScreen: UIViewController {
    
    var camera : LLSimpleCamera!
    var lblError : UILabel?
    var btnSnap : UIButton!
    var btnSwitch : UIButton!
    
    var nameFile = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBarHidden = true
        
        let screenRect = UIScreen.mainScreen().bounds
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        self.camera.attachToViewController(self, withFrame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
        self.camera.fixOrientationAfterCapture = false
        
        self.camera.onError = {(camera, error) in
            print("Camera error: \(error)")
            if let err = error{
                if err.domain == LLSimpleCameraErrorDomain{
                    if err.code == Int(LLSimpleCameraErrorCodeCameraPermission.rawValue) || error.code == Int(LLSimpleCameraErrorCodeMicrophonePermission.rawValue){
                        self.lblError?.removeFromSuperview()
                        
                        let label = UILabel(frame: CGRectZero)
                        label.text = "We need permission for the camera.\nPlease go to your settings."
                        label.numberOfLines = 2
                        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        label.backgroundColor = UIColor.clearColor()
                        label.font = UIFont(name: "AvenirNext-DemiBold", size: 13)
                        label.textColor = UIColor.whiteColor()
                        label.textAlignment = NSTextAlignment.Center
                        label.sizeToFit()
                        label.center = CGPointMake(screenRect.size.width/2, screenRect.size.height/2)
                        self.lblError = label
                        self.view.addSubview(self.lblError!)
                    }
                }
            }
        }
        
        // camera button control
        
        self.btnSnap = UIButton(type: UIButtonType.Custom)
        self.btnSnap.frame = CGRectMake(0, 0, 70,70)
        self.btnSnap.clipsToBounds = true
        self.btnSnap.layer.cornerRadius = self.btnSnap.frame.width/2
        self.btnSnap.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnSnap.layer.borderWidth = 2
        self.btnSnap.backgroundColor = UIColor.redColor()
        self.btnSnap.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.btnSnap.layer.shouldRasterize = true
        self.btnSnap.addTarget(self, action: "snapButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.btnSnap)
        
        
        if LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable(){
            self.btnSwitch = UIButton(type: UIButtonType.System)
            self.btnSwitch.frame = CGRectMake(0, 0, 49, 42)
            self.btnSwitch.tintColor = UIColor.whiteColor()
            self.btnSwitch.setImage(UIImage(named:"camera-switch.png"), forState: UIControlState.Normal)
            self.btnSwitch.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
            self.btnSwitch.addTarget(self, action: "switchButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(self.btnSwitch)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.camera.start()
    }
    
    func switchButtonPressed(){
        self.camera.togglePosition()
    }
    
    
    func applicationDocumentsDirectory() ->NSURL?{
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
    }
    
    func snapButtonPressed(){
        if !self.camera.recording{
            self.btnSwitch.hidden = true
            self.btnSwitch.layer.borderColor = UIColor.yellowColor().CGColor
            self.btnSwitch.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
            // start record 
            if let temUrl = self.applicationDocumentsDirectory(){
                let outputUrl = temUrl.URLByAppendingPathComponent(self.nameFile).URLByAppendingPathExtension("mov")
                self.camera.startRecordingWithOutputUrl(outputUrl)
            }
            
        }else{
            self.btnSwitch.hidden = false
            self.btnSnap.layer.borderColor = UIColor.whiteColor().CGColor
            self.btnSnap.backgroundColor = UIColor.redColor()
            self.camera.stopRecording({ (camera, url, erro) in
                // day qua trang playvideo
                
            })
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.camera.view.frame = self.view.bounds
        self.btnSnap.center = self.view.center
        self.btnSnap.frame = CGRectMake(self.camera.view.frame.width - self.btnSnap.frame.size.width*2, self.btnSnap.frame.origin.y, self.btnSnap.frame.size.width, self.btnSnap.frame.size.height)
        self.btnSwitch.center = self.btnSnap.center
        self.btnSwitch.frame = CGRectMake(self.btnSwitch.frame.origin.x, 10, self.btnSwitch.frame.size.width, self.btnSwitch.frame.size.height)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}