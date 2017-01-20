//
//  SubmitVideoReviewScreen.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/21/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
//
//  ReviewVideoScreen.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
import AVFoundation

class SubmitVideoReviewScreen : MyViewController{
    var avPlayer : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    
    var btnDiscard : UIButton!
    var btnSubmit : UIButton!
    
    var videoPaths : NSArray!
    let padding:CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        self.avPlayer = AVPlayer(URL: self.videoPaths.lastObject as! NSURL)
        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
        let screenRect = UIScreen.mainScreen().bounds
        self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)
        self.view.layer.addSublayer(self.avPlayerLayer)
    
        let buttonWidth = screenRect.width*2/6
        self.btnDiscard = UIButton(type: UIButtonType.System)
        self.btnDiscard.frame = CGRectMake( self.view.center.x - padding - buttonWidth, screenRect.height - 7*padding, buttonWidth, 5*padding)
        self.btnDiscard.backgroundColor = hexStringToUIColor("bab6b4").colorWithAlphaComponent(0.7)
        self.btnDiscard.setTitle("DISCARD", forState: UIControlState.Normal)
        self.btnDiscard.setTitleColor(hexStringToUIColor("6f6f6f"), forState: UIControlState.Normal)
        self.btnDiscard.addTarget(self, action: #selector(SubmitVideoReviewScreen.discardSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.btnDiscard)
        
        self.btnSubmit = UIButton(type: UIButtonType.System)
        self.btnSubmit.frame = CGRectMake( self.view.center.x + padding, screenRect.height - 7*padding, buttonWidth, 5*padding)
        self.btnSubmit.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.7)
        self.btnSubmit.setTitle("SUBMIT", forState: UIControlState.Normal)
        self.btnSubmit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btnSubmit.addTarget(self, action: #selector(SubmitVideoReviewScreen.submitVideo), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.btnSubmit)
        
        GlobalServices.fTPServices.submitVideoFinish = {(url,questionID,isOK,message) in
            if isOK{
                if GlobalServices.fTPServices.questionCount == 0{
                    // upload finish
                    self.hideLoadingView()
                    CongratulationAlert.show({ 
                        self.closeScreen()
                    })
                }
            }else{
                self.hideLoadingView()
                if let mess = message{
                    self.showErrorUploadAlert("Error", message: mess)
                }else{
                    self.showErrorUploadAlert("Error", message: "Submit not successful")
                }
            }
        }
        
    }
    
    func showErrorUploadAlert(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okiAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: { (action) in
            self.closeScreen()
        })
        alertViewController.addAction(okiAction)
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    // Action
    
    func discardSubmit() {
        self.btnSubmit.hidden = true
        self.btnDiscard.hidden = true
        ConfirmSubmitAlert.show { (isSubmit) in
            if isSubmit{
                self.submitVideo()
            }else{
                if let navi = self.navigationController?.viewControllers{
                    for viewcontroller in navi{
                        if let cameraGuide = viewcontroller as? CameraGuideScreen{
                            self.navigationController?.popToViewController(cameraGuide, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    private func closeScreen(){
        if let navi = self.navigationController?.viewControllers{
            for viewcontroller in navi{
                if let cameraGuide = viewcontroller as? CameraGuideScreen{
                    self.navigationController?.popToViewController(cameraGuide, animated: true)
                }
            }
        }
    }
    
    func submitVideo() {
        if !isConnectedToNetwork() {
            showAlertWithMessage(AppErrorCode.NoInternetConnection.rawValue)
            return
        }
        self.btnSubmit.hidden = true
        self.btnDiscard.hidden = true
        self.showLoadingView()
        GlobalServices.fTPServices.uploadVideoReview(self.videoPaths.lastObject as! NSURL, questionID: self.videoPaths.count, isFinal: true, handleComplete: { (isOK, urlReturn,message) in
            GlobalServices.fTPServices.submitVideoFinish?(url: self.videoPaths.lastObject as! NSURL,questionID: self.videoPaths.count,isOK: isOK,message: message)
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let screenSize = UIScreen.mainScreen().bounds.size
        let buttonWidth = screenSize.width*2/6
        self.btnDiscard.frame = CGRectMake( self.view.center.x - padding - buttonWidth, screenSize.height - 7*padding, buttonWidth, 5*padding)
        self.btnSubmit.frame = CGRectMake( self.view.center.x + padding, screenSize.height - 7*padding, buttonWidth, 5*padding)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
