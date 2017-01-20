//
//  ReviewVideoScreen.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
import AVFoundation

class ReviewVideoScreen : MyViewController{
    var nextScreenIsLandcape = true
    
    var questionIndex:Int = 0
    var videoUrl : NSURL!
    
    let topViewHeigh:CGFloat = 40
    var avPlayer : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    
    var topView : CameraRecordToolBar!
    var botView : CameraRecordToolBar!
    var centerView : CameraQuestionView!
    
    let padding:CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        self.avPlayer = AVPlayer(URL: self.videoUrl)
        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.None
        
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ReviewVideoScreen.playerItemDidReachEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.avPlayer.currentItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:  #selector(ReviewVideoScreen.playerDidFinishPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.avPlayer.currentItem)
        let screenRect = UIScreen.mainScreen().bounds
        self.avPlayerLayer.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)
        self.view.layer.addSublayer(self.avPlayerLayer)
        
        
        // Custom layout
        // Top view
        self.topView = CameraRecordToolBar.creat()
        self.topView.setData(CGRectMake(0, 0, screenRect.width, topViewHeigh), btnLTitle: "Exit", btnRTitle: nil, btnLImg: "left-arrow", btnRImg: nil,isShowTitle:  false)
        self.view.addSubview(self.topView)
        
        self.topView.leftButtonTouch = {(butotn) in
            // exit to contruction
            if let navi = self.navigationController?.viewControllers{
                for viewcontroller in navi{
                    if let cameraGuide = viewcontroller as? CameraGuideScreen{
                        self.nextScreenIsLandcape = false
                        self.navigationController?.popToViewController(cameraGuide, animated: true)
                    }
                }
            }
        }
        
        self.botView = CameraRecordToolBar.creat()
        self.botView.setData(CGRectMake(0, screenRect.size.height - topViewHeigh, screenRect.width, topViewHeigh), btnLTitle: "RETAKE", btnRTitle: "NEXT", btnLImg: "ic_retake", btnRImg: "ic_next",isShowTitle:  false)
        self.botView.leftTitleButtonConstraint.constant = 50
        self.view.addSubview(self.botView)
        // retake
        self.botView.leftButtonTouch = {(butotn) in
            // remove last video
            GlobalServices.ultilityServices.videoRecoderScreen.videoPaths.removeObject(GlobalServices.ultilityServices.videoRecoderScreen.videoPaths.lastObject!)
            self.nextScreenIsLandcape = true
            self.navigationController?.popViewControllerAnimated(true)
        }
        // next question
        self.botView.rightButtonTouch = {(button) in
            if self.questionIndex < (GlobalServices.fTPServices.totalQuestion - 1){
                // questionid lay tu 1
                GlobalServices.fTPServices.uploadVideoReview(self.videoUrl, questionID: self.questionIndex + 1, isFinal: ((GlobalServices.ultilityServices.videoRecoderScreen.question.count - 1) == self.questionIndex), handleComplete: { (isOK, urlReturn,message) in
                    GlobalServices.fTPServices.submitVideoFinish?(url: self.videoUrl,questionID: self.questionIndex,isOK: isOK,message:message)
                })
                GlobalServices.ultilityServices.showVideoRecodScreen(self.navigationController)
            }else{
                // submit video screen
                GlobalServices.ultilityServices.showVideoSubmitScreen(self.navigationController)
            }
        }
        
        // center view
        self.centerView = CameraQuestionView.creat()
        self.centerView.frame = CGRectMake(0, 0, screenRect.width - 3*padding, topViewHeigh)
        self.view.addSubview(self.centerView)
        self.updateQuestionData()
        self.centerView.buttonPlayTouch = {(button) in
            print("play video")
            self.centerView.btnPlay.hidden = true
            self.centerView.hidden = true
            self.botView.hidden = true
            self.topView.hidden = true
            self.avPlayer.play()
        }
    }
    
    private func updateQuestionData() {
        self.centerView.setCurrentQuestion(false ,indexQuestion: self.questionIndex, question: nil)
    }
    
    
    // avplayer delegate
    func playerDidFinishPlaying(notification : NSNotification){
        self.centerView.btnPlay.hidden = false
        self.centerView.hidden = false
        self.botView.hidden = false
        self.topView.hidden = false
        self.avPlayer.pause()
        self.centerView.hidden = false
        self.view.bringSubviewToFront(self.centerView)
        print("avplayer finish")
    }
    func playerItemDidReachEnd(notification:NSNotification)  {
        if let p = notification.object as? AVPlayerItem{
            p.seekToTime(kCMTimeZero)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if !nextScreenIsLandcape{
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let screenSize = UIScreen.mainScreen().bounds.size
        self.topView.frame = CGRectMake(0, 0, screenSize.width, topViewHeigh)
        self.centerView.frame = CGRectMake(padding*3/2, self.topView.frame.origin.y + self.topView.frame.height, screenSize.width - 3*padding, screenSize.height - 2*topViewHeigh )
        self.botView.frame = CGRectMake(0, screenSize.height - topViewHeigh, screenSize.width, topViewHeigh)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
