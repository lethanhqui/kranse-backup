//
//  ConfirmSubmitAlert.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/21/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class ConfirmSubmitAlert: UIView {
    
    var alertAction :((isSubmit:Bool)->())?
    @IBOutlet weak var lblContent : UILabel!
    @IBOutlet weak var btnSubmit : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func submit (sender:UIButton){
        self.alertAction?(isSubmit: true)
    }
    
    @IBAction func cancel(sender: UIButton){
        self.alertAction?(isSubmit: false)
    }
    
    class  func show(action:((isSubmit:Bool)->())?) {
        let alertView =   NSBundle.mainBundle().loadNibNamed("ConfirmSubmitAlert", owner: self, options: nil).first as! ConfirmSubmitAlert
        let containView = UIView(frame: UIScreen.mainScreen().bounds)
        containView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        containView.addSubview(alertView)
        alertView.center = containView.center
        containView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        containView.alpha = 0
        UIApplication.sharedApplication().windows[0].addSubview(containView)
        UIView.animateWithDuration(0.3) { 
            containView.alpha = 1
            containView.transform = CGAffineTransformMakeScale(1, 1)
        }
        alertView.alertAction = {(isSubmit) in
            containView.removeFromSuperview()
            action?(isSubmit: isSubmit)
        }
    }
}

class CongratulationAlert: UIView {
    
    var alertFinish :(()->())?
    @IBOutlet weak var lblContent : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func closeAlert(){
        self.alertFinish?()
    }

    
    class  func show(action:(()->())?) {
        let alertView =   NSBundle.mainBundle().loadNibNamed("CongratulationAlert", owner: self, options: nil).first as! CongratulationAlert
        let containView = UIView(frame: UIScreen.mainScreen().bounds)
        containView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        containView.addSubview(alertView)
        alertView.center = containView.center
        containView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        containView.alpha = 0
        UIApplication.sharedApplication().windows[0].addSubview(containView)
        UIView.animateWithDuration(0.3) {
            containView.alpha = 1
            containView.transform = CGAffineTransformMakeScale(1, 1)
        }
        alertView.alertFinish = {() in
            containView.removeFromSuperview()
            action?()
        }
    }
}