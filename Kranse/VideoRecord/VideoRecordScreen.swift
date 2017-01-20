//
//  VideoRecordScreen.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class VideoRecordScreen: MyViewController {
    var nextScreenIsLandcape = true
    
    let limitTimeOfVideo:Int = 30
    let topViewHeigh:CGFloat = 40
    let padding:CGFloat = 10
    
    var camera : LLSimpleCamera!
    var lblError : UILabel?
    
    // Record View
    var lblTapToRecord : UILabel!
    var btnSnap : UIButton!
    var progressBar : MBCircularProgressBarView!
    
    // top view
    var topView: CameraRecordToolBar!
    
    // question view
    var questionView : CameraQuestionView!
    
    // recorder Timer
    var timer : NSTimer?
    var nameFile = "video"
    
    var videoPaths = NSMutableArray()
    
    
    var timeCount:Int = 0
    var question = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalServices.ultilityServices.videoRecoderScreen = self
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBarHidden = true
        let screenRect = UIScreen.mainScreen().bounds
        timeCount = self.limitTimeOfVideo
        
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPreset1280x720, position: LLCameraPositionRear, videoEnabled: true)
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
                        label.font = UIFont(name: "OpenSans-Regular", size: 13)
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
        lblTapToRecord = UILabel(frame: CGRectZero)
        lblTapToRecord.text = "Tap to record"
        lblTapToRecord.numberOfLines = 1
        lblTapToRecord.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblTapToRecord.backgroundColor = UIColor.clearColor()
        lblTapToRecord.font = UIFont(name: "OpenSans-Regular", size: 12)
        lblTapToRecord.textColor = UIColor.whiteColor()
        lblTapToRecord.textAlignment = NSTextAlignment.Center
        lblTapToRecord.sizeToFit()
        lblTapToRecord.center = CGPointMake(screenRect.size.width/2, screenRect.size.height/2)
        self.view.addSubview(self.lblTapToRecord)
        
        self.btnSnap = UIButton(type: UIButtonType.Custom)
        self.btnSnap.frame = CGRectMake(0, 0, 70,70)
        self.btnSnap.clipsToBounds = true
        self.btnSnap.layer.cornerRadius = self.btnSnap.frame.width/2
        self.btnSnap.layer.borderColor = UIColor.whiteColor().CGColor
        self.btnSnap.layer.borderWidth = 6
        self.btnSnap.backgroundColor = UIColor.redColor()
        self.btnSnap.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.btnSnap.layer.shouldRasterize = true
        self.btnSnap.addTarget(self, action: #selector(VideoRecordScreen.snapButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.btnSnap)
        
        self.progressBar = MBCircularProgressBarView(frame: self.btnSnap.frame)
        self.progressBar.maxValue = CGFloat(limitTimeOfVideo)
        self.progressBar.value = CGFloat(limitTimeOfVideo)
        self.progressBar.progressLineWidth = 5
        self.progressBar.emptyLineWidth = 5
        self.progressBar.showValueString = false
        self.progressBar.showUnitString = false
        self.progressBar.progressStrokeColor = UIColor.clearColor()
        self.progressBar.backgroundColor = UIColor.clearColor()
        self.progressBar.progressColor =  UIColor.whiteColor()
        self.progressBar.emptyLineColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        self.progressBar.progressAngle = 100
        self.view.addSubview(self.progressBar)
        self.progressBar.transform = CGAffineTransformMakeRotation((-180.0 * CGFloat(M_PI)) / 180.0)
        self.progressBar.hidden = true
        
        ////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////
        // top view
        self.topView = CameraRecordToolBar.creat()
        if LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable(){
            self.topView.setData(CGRectMake(0, 0, screenRect.width, topViewHeigh), btnLTitle: "Back", btnRTitle: nil, btnLImg: "ic_back", btnRImg: "camera-switch")
        }else{
            self.topView.setData(CGRectMake(0, 0, screenRect.width, topViewHeigh), btnLTitle: "Back", btnRTitle: nil, btnLImg: "cancel", btnRImg: nil)
        }
        self.view.addSubview(self.topView)
        
        // topview action
        self.topView.leftButtonTouch = {(button) in
            self.camera.stop()
            self.nextScreenIsLandcape = false
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.topView.rightButtonTouch = {(button) in
            self.switchButtonPressed()
        }
        
        ////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////
        // Centre Question View
        self.questionView = CameraQuestionView.creat()
        self.questionView.frame = CGRectMake(0, 0, screenRect.width - 30, topViewHeigh)
        self.view.addSubview(self.questionView)
        self.questionView.hidden = true
        if !isConnectedToNetwork() {
            showAlertWithMessage(AppErrorCode.NoInternetConnection.rawValue)
            return
        }
        self.showLoadingView()
        BaseApiService.getquestionLists(["token":AppRuntime.sharedInstance.userToken!]) { (res) in
            self.hideLoadingView()
            if let result =  res{
                guard let status  = result["status"] as? String else {return}
                if status == APIStatus.success.rawValue{
                    if let resultdic = result["data"] as? NSDictionary, arr = resultdic["result"] as? NSArray{
                        for item in arr{
                            if let dic = item as? NSDictionary{
                                if let question = dic["content"] as? String{
                                    let str = question.stringByReplacingOccurrencesOfString("[##]", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                    self.question.append(str)
                                }
                            }
                        }
                        GlobalServices.fTPServices.questionCount = self.question.count
                        GlobalServices.fTPServices.totalQuestion = self.question.count
                        self.updateQuestionData()
                        self.questionView.hidden = false
                    }
                }else if status == APIStatus.error.rawValue{
                    guard let message = result["message"] as? String else {return}
                    self.showAlertWithMessage(message)
                }
            }else{
                self.showAlertWithMessage(AppErrorCode.Unknown.rawValue)
            }
        }
    }
    
    // update question
    private func updateQuestionData() {
        if self.question.count > 0{
            questionView.setCurrentQuestion(true ,indexQuestion: self.videoPaths.count, question: self.question[videoPaths.count])
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if !self.nextScreenIsLandcape{
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateQuestionData()
        self.camera.start()
    }
    
    ////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////
    // timer for recordding
    func countTime() {
        timeCount = timeCount - 1
        self.updateProgressBar()
        self.topView.updateTimeTitle(self.limitTimeOfVideo - timeCount)
        if timeCount <= 0{
            dispatch_async(dispatch_get_main_queue(),{
                print("stop record")
                self.timeCount = self.limitTimeOfVideo
                self.stopRecord()
                self.timer?.invalidate()
                self.timer = nil
                
            })
        }
    }
    
    private func updateProgressBar (){
        self.progressBar.setValue(CGFloat(self.timeCount), animateWithDuration: 1)
    }
    
    ////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////
    // button action
    
    func switchButtonPressed(){
        self.camera.togglePosition()
    }
    
    func snapButtonPressed(){
        if !self.camera.recording{
            self.btnSnap.hidden = true
            self.lblTapToRecord.hidden = true
            self.topView.hideAllButton(true)
            self.progressBar.hidden = false
            self.questionView.hidden = true
            // start record
            if let temUrl = self.applicationDocumentsDirectory(){
                let outputUrl = temUrl.URLByAppendingPathComponent("\(self.nameFile)\(self.videoPaths.count)").URLByAppendingPathExtension("mov")
                self.camera.startRecordingWithOutputUrl(outputUrl)
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(VideoRecordScreen.countTime), userInfo: nil, repeats: true)
            }
            
        }
    }
    
    private func stopRecord(){
        self.camera.stopRecording({ (camera, url, erro) in
            // day qua trang playvideo
            dispatch_async(dispatch_get_main_queue(),{
                self.videoPaths.addObject(url)
                self.showCameraReviewVideo({
                    self.topView.hideAllButton(false)
                    self.questionView.hidden = false
                    self.view.bringSubviewToFront(self.questionView)
                    self.btnSnap.hidden = false
                    self.lblTapToRecord.hidden = false
                    self.progressBar.hidden = true
                    self.progressBar.value = CGFloat(self.limitTimeOfVideo)
                    self.topView.updateTimeTitle(0)
                    self.btnSnap.layer.borderColor = UIColor.whiteColor().CGColor
                    self.btnSnap.backgroundColor = UIColor.redColor()
                })
            })
            print("stop recording")
        })
    }
    
    private func showCameraReviewVideo(handleComplete:(()->())){
        if let url = self.videoPaths.lastObject as? NSURL{
            nextScreenIsLandcape = true
            let videoReview = ReviewVideoScreen()
            videoReview.videoUrl = url
            videoReview.questionIndex = self.videoPaths.count - 1
            self.navigationController?.pushViewController(videoReview, completion: {
                handleComplete()
            })
        }
    }
    
    ////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.camera.view.frame = self.view.bounds
        activityIndicator?.center = self.view.center
        activityIndicator?.frame = self.view.bounds
        self.topView.frame = CGRectMake(0, 0, self.camera.view.frame.width, topViewHeigh)
        self.questionView.frame = CGRectMake(padding*3/2, self.topView.frame.origin.y + self.topView.frame.height, self.camera.view.frame.width - 3*padding, self.camera.view.frame.height/2)
        self.btnSnap.center = self.view.center
        self.btnSnap.frame = CGRectMake(self.btnSnap.frame.origin.x, self.camera.view.frame.size.height - self.btnSnap.frame.size.height - self.padding, self.btnSnap.frame.size.width, self.btnSnap.frame.size.height)
        self.lblTapToRecord.center = self.view.center
        self.lblTapToRecord.frame = CGRectMake(self.lblTapToRecord.frame.origin.x, self.btnSnap.frame.origin.y - 2*padding - padding/2, self.lblTapToRecord.frame.size.width, 2*padding)
        self.progressBar.center = self.btnSnap.center
    }
    
    func applicationDocumentsDirectory() ->NSURL?{
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.LandscapeRight
    }
}