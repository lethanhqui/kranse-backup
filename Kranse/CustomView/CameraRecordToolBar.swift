//
//  CameraRecordToolBar.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
import UIKit
class CameraRecordToolBar: UIView {
    
    @IBOutlet private weak var btnLeft : UIButton!
    @IBOutlet private weak var btnRight : UIButton!
    @IBOutlet private weak var lblTitle : UILabel!
    
    @IBOutlet private weak var lblLeftButtonTitle : UILabel!
    @IBOutlet private weak var lblRightButtonTitle : UILabel!
    @IBOutlet weak var leftTitleButtonConstraint: NSLayoutConstraint!
    
    var leftButtonTouch : ((button:UIButton)->())?
    var rightButtonTouch : ((button:UIButton)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.btnRight.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.btnLeft.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    func setData(frame:CGRect, btnLTitle:String?, btnRTitle:String?, btnLImg : String?, btnRImg : String?, isShowTitle : Bool = true){
        self.lblTitle.hidden = !isShowTitle
        if btnLTitle == nil && btnLImg == nil{
            self.btnLeft.hidden = true
            self.lblLeftButtonTitle.hidden = true
        }else{
            self.btnLeft.hidden = false
            if let title = btnLTitle{
                self.lblLeftButtonTitle.text = title
            }else{
                self.lblLeftButtonTitle.text = ""
            }
            self.btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 0)
            self.btnLeft.setImage(UIImage(named:btnLImg!), forState: UIControlState.Normal)
        }
        
        if btnRTitle == nil && btnRImg == nil{
            self.btnRight.hidden = true
            self.lblRightButtonTitle.hidden = true
        }else{
            self.btnRight.hidden = false
            if let title = btnRTitle{
                self.lblRightButtonTitle.text = title
            }else{
                self.lblRightButtonTitle.text = ""
            }
            self.btnRight.setImage(UIImage(named:btnRImg!), forState: UIControlState.Normal)
        }
    }
    
    func updateTimeTitle(time : Int) {
        let str = String(format: "00:%02d", time)
        self.lblTitle.text  =  str
    }
    
    func hideAllButton(isHide : Bool){
        self.btnRight.hidden = isHide
        self.btnLeft.hidden = isHide
        self.lblLeftButtonTitle.hidden = isHide
        self.lblRightButtonTitle.hidden = isHide
    }
    
    @IBAction func btnLeftTouch (sender:UIButton){
        self.leftButtonTouch?(button: sender)
    }
    
    @IBAction func btnRightTouch(sender: UIButton){
        self.rightButtonTouch?(button: sender)
    }
    class func creat() -> CameraRecordToolBar {
        return NSBundle.mainBundle().loadNibNamed("CameraRecordToolBar", owner: self, options: nil).first as! CameraRecordToolBar
    }
}