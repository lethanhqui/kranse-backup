//
//  UltilityServices.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class UltilityServices: NSObject {
    
    var videoRecoderScreen : VideoRecordScreen!
    var questionCount = 0
    var submitVideoFinish:((url:NSURL, questionID : Int, isOK:Bool)->())?
    
    func  showVideoRecodScreen(navi : UINavigationController?) {
        if let navigation = navi where !navigation.viewControllers.contains(self.videoRecoderScreen){
            if let videoScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VideoRecordScreen") as? VideoRecordScreen{
                navi?.pushViewController(videoScreen, animated: true)
            }
        }else{
            self.popViewControllerWithCustomAnimation(navi)
        }
    }
    
    private func popViewControllerWithCustomAnimation(navigation:UINavigationController?){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        navigation?.view.layer.addAnimation(transition, forKey: nil)
        navigation?.popViewControllerAnimated(false)
    }

    
    func showVideoSubmitScreen(navigation : UINavigationController?){
        if  GlobalServices.ultilityServices.videoRecoderScreen.videoPaths.count > 0{
            let submitVideo = SubmitVideoReviewScreen()
            submitVideo.videoPaths = GlobalServices.ultilityServices.videoRecoderScreen.videoPaths
            navigation?.pushViewController(submitVideo, animated: true)
        }
    }
    
    func showErrorAlert(view:UIViewController, title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okiAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil)
        alertViewController.addAction(okiAction)
        view.presentViewController(alertViewController, animated: true, completion: nil)
    }
}