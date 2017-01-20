//
//  CameraQuestionView.swift
//  Kranse
//
//  Created by ITV MAC 01 on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class CameraQuestionView: UIView {
    
    @IBOutlet weak var btnPlay : UIButton!
    
    @IBOutlet weak var lblQuestion : UILabel!
    
    var iconWidth:CGFloat = 40
    
    var buttonPlayTouch : ((button : UIButton)->())?
    var questionItems = [UILabel]()
    var questionImgItem =  [UIImageView]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.btnPlay.hidden = true
        
    }
    
    class func creat() -> CameraQuestionView {
        return NSBundle.mainBundle().loadNibNamed("CameraQuestionView", owner: self, options: nil).first as! CameraQuestionView
    }
    
    func setCurrentQuestion(isRecord : Bool,indexQuestion : Int, question : String?)  {
        if  indexQuestion >= GlobalServices.fTPServices.totalQuestion{
            return
        }
        var curenX = (UIScreen.mainScreen().bounds.size.width - CGFloat(GlobalServices.fTPServices.totalQuestion) * (iconWidth + 15)) / 2
        for index in 0...(GlobalServices.fTPServices.totalQuestion - 1){
            var cga : CGAffineTransform!
            var str = ""
            var imgName = ""
            var lblQ : UILabel!
            if isRecord {
                if self.questionItems.count < GlobalServices.fTPServices.totalQuestion{
                    lblQ = UILabel(frame: CGRectMake(curenX  + CGFloat(index) * (iconWidth + 15),15 ,iconWidth,iconWidth))
                    lblQ.layer.cornerRadius = iconWidth/2
                    lblQ.backgroundColor = UIColor.redColor()
                    lblQ.textColor = UIColor.whiteColor()
                    lblQ.clipsToBounds = true
                    lblQ.textAlignment = NSTextAlignment.Center
                    lblQ.font = UIFont(name: "OpenSans-Regular", size: 13)
                    self.questionItems.append(lblQ)
                    self.addSubview(lblQ)
                }else{
                    lblQ = self.questionItems[index]
                }
                
                curenX = curenX  + CGFloat(index)
                if index < indexQuestion{
                    cga = CGAffineTransformMakeScale(0.6, 0.6)
                    str = "\(index+1)"
                }else if index > indexQuestion{
                    cga = CGAffineTransformMakeScale(0.2, 0.2)
                    str = ""
                }else{
                    cga = CGAffineTransformMakeScale(1, 1)
                    str = "Q\(index+1)"
                }
                lblQ.text = str
                UIView.animateWithDuration(0.2, animations: {
                    lblQ.transform = cga
                })
            }else{
                let img = UIImageView(frame: CGRectMake(curenX  + CGFloat(index) * (iconWidth + 15),15 ,iconWidth,iconWidth))
                img.layer.cornerRadius = iconWidth/2
                img.backgroundColor = UIColor.redColor()
                img.clipsToBounds = true
                self.questionImgItem.append(img)
                self.addSubview(img)
                self.btnPlay.hidden = false
                if index > indexQuestion{
                    cga = CGAffineTransformMakeScale(0.2, 0.2)
                    imgName = ""
                }else{
                    cga = CGAffineTransformMakeScale(1, 1)
                    imgName = "ic_tick"
                }
                img.hidden = false
                img.image = UIImage(named: imgName)
                UIView.animateWithDuration(0.2, animations: {
                    img.transform = cga
                })
            }
        }
        if let str = question where isRecord{
            self.lblQuestion.hidden = false
            self.lblQuestion.text = str
            
        }else{
            self.lblQuestion.hidden = true
            self.lblQuestion.text = ""
        }
    }
    
    @IBAction func playVideo(sender:UIButton){
        self.buttonPlayTouch?(button: sender)
    }
}