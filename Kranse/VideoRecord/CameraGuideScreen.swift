//
//  CameraGuideScreen.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
import UIKit
class CameraGuideScreen: MyViewController {
    
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoTopMargin: NSLayoutConstraint!
    @IBOutlet weak var titleTopMargin: NSLayoutConstraint!
    @IBOutlet weak var titleBottomMargin: NSLayoutConstraint!
    //constraint
    @IBOutlet weak var textLeftMargin: NSLayoutConstraint!
    
    @IBOutlet weak var textRightMargin: NSLayoutConstraint!
    //
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonBottomMargin: NSLayoutConstraint!
    
    
    @IBOutlet weak var lbGuide: UILabel!
    @IBOutlet weak var lbGuideP2: UILabel!
    @IBOutlet weak var lbGuideP3: UILabel!
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet var topview : UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lbMessageBottom: UILabel!
    @IBOutlet weak var btnGotIt: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBarHidden = true
        self.topview.backgroundColor = UIColor.clearColor()
        scrollView.scrollEnabled = false
        if         UIDevice.currentDevice().modelName.containsString("iPhone 5"){
            UIView.animateWithDuration(0.1) {
                self.view.updateConstraintsIfNeeded()
            }
            
        } else if (UIDevice.currentDevice().modelName.containsString("iPhone 4") || UIScreen.mainScreen().bounds.size.height == 480.0){
            
        }
        btnBack.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        // hidden label message submit previous in a month
        lbMessageBottom.hidden = true
    }
    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
        if UIDevice.currentDevice().modelName.containsString("iPhone 5") || UIScreen.mainScreen().bounds.size.height == 568.0{
            titleTopMargin.constant = 20
            titleBottomMargin.constant = 10
            logoHeightConstraint.constant = 80
            textLeftMargin.constant = 15
            textRightMargin.constant = 15
            buttonBottomMargin.constant = 20
            lbGuide.font =  lbGuide.font.fontWithSize(12)
            lbGuideP2.font = lbGuide.font
            lbGuideP3.font = lbGuide.font
            
        }else if UIDevice.currentDevice().modelName.containsString("iPhone 4") || UIScreen.mainScreen().bounds.size.height == 480.0{
            logoTopMargin.constant = 20
            titleTopMargin.constant = 15
            titleBottomMargin.constant = 10
            logoHeightConstraint.constant = 60
            buttonHeightConstraint.constant = 40
            textLeftMargin.constant = 15;
            textRightMargin.constant = 15
            buttonBottomMargin.constant = 20
            lbTitle.font = lbTitle.font.fontWithSize(20);
            lbGuide.font =  lbGuide.font.fontWithSize(11)
            lbGuideP2.font = lbGuide.font
            lbGuideP3.font = lbGuide.font
        }
        self.view.updateConstraintsIfNeeded()

    }
    var islandscape = true
    @IBAction func closeScreen(sender: UIButton){
        self.islandscape = false
//        self.navigationController?.popViewControllerAnimated(true)
        var has = false
        if let viewcontrollers = self.navigationController?.viewControllers{
            for viewcontroller in viewcontrollers{
                if let _ = viewcontroller as? HomeViewController{
                    has = true
                    self.navigationController?.popToViewController(viewcontroller, animated: true)
                    break
                }
            }
            if has == false {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.islandscape{
            let value = UIInterfaceOrientation.Portrait.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        if self.islandscape{
            let value = UIInterfaceOrientation.LandscapeRight.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
        }
    }
    
    @IBAction func showCameraReview(sender:UIButton){
        self.showLoadingView()
        BaseApiService.reviewCheck(true) { (isOK, checkOk, message) in
            self.hideLoadingView()
            if isOK{
                if checkOk{
                    if let cameraReviewScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VideoRecordScreen") as? VideoRecordScreen{
                        self.navigationController?.pushViewController(cameraReviewScreen, animated: true)
                    }
                }else{
                    self.lbMessageBottom.hidden = false
                    self.btnGotIt.hidden = true
                }
            }else{
                if  let mess = message{
                    self.showAlertWithMessage(mess)
                }else{
                    self.showAlertWithMessage(AppErrorCode.Unknown.rawValue)
                }
            }
        }
    }
    
}