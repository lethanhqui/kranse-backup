//
//  ScholarshipIntriViewController.swift
//  Kranse
//
//  Created by macbook on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class ScholarshipIntriViewController: BaseViewController {
    
    @IBOutlet weak var logoTopMargin: NSLayoutConstraint!
    @IBOutlet weak var titleBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var titleTopMargin: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbGuide: UILabel!
    @IBOutlet weak var lbGuideP3: UILabel!
    @IBOutlet weak var lbGuideP2: UILabel!
    
    @IBOutlet weak var textLeftMargin: NSLayoutConstraint!
    
    @IBOutlet weak var textRightMargin: NSLayoutConstraint!
    
    @IBOutlet weak var lbMessageBottom: UILabel!
    @IBOutlet weak var btnGotIt: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hidden message submit core in a month
        lbMessageBottom.hidden = true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showBackButton("Back",black: true)
        setNavigatorBarTranslucent(true)
       
    }
    override func viewWillLayoutSubviews() {
        if UIDevice.currentDevice().modelName.containsString("iPhone 5") || UIScreen.mainScreen().bounds.size.height == 568.0{
            titleTopMargin.constant = 20
            titleBottomMargin.constant = 10
            logoHeightConstraint.constant = 80
            textLeftMargin.constant = 15;
            textRightMargin.constant = 15
            buttonBottomMargin.constant = 20
            lbGuide.font = lbTitle.font.fontWithSize(12)
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
            lbGuide.font = lbTitle.font.fontWithSize(11)
            lbGuideP2.font = lbGuide.font
            lbGuideP3.font = lbGuide.font
        }
        print("iphone 4 : \(UIDevice.currentDevice().modelName) --- >\(UIScreen.mainScreen().bounds.size.height)")
    }
    override func pressedBack(sender: UIButton) {
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
    @IBAction func showSholarshipTakePicture(sender:UIButton){
        self.showLoadingView()
        BaseApiService.reviewCheck(false) { (isOK, checkOk, message) in
            self.hideLoadingView()
            if isOK{
                if checkOk{
                if let cameraTakeScreen = UIStoryboard(name: "Guide", bundle: nil).instantiateViewControllerWithIdentifier("ScholarshipTakePictureViewController") as? ScholarshipTakePictureViewController{
                    self.navigationController?.pushViewController(cameraTakeScreen, animated: true)
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