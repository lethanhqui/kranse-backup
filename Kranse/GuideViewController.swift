//
//  GuideViewController.swift
//  Kranse
//
//  Created by macbook on 9/19/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
protocol GuideViewDelegate {
    func didNextGuideViewAtIndex(index:Int)
}
class GuideViewController: UIViewController {
    
    @IBOutlet weak var imageviewIntro: UIImageView!
    
    @IBOutlet weak var btnNextWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnNextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    
    var index:Int?
    var delegate: GuideViewDelegate?
    var firstTime:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.addTarget(self, action: #selector(actionNext(_:)), forControlEvents: .TouchUpInside)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let pageIndex = index else{return}
        btnNext.imageView?.contentMode = .ScaleAspectFit
        guard firstTime else {return}
        firstTime = false
        let bgIndex = index! + 1
        imageviewIntro.image = UIImage(named: "bg_guide_step_\(bgIndex).png")
        var is45 = false
        if UIDevice.currentDevice().modelName.containsString("iPhone 5") || UIScreen.mainScreen().bounds.size.height == 568.0{
            btnNextHeightConstraint.constant = 45
            is45 = true
            
        }else if UIDevice.currentDevice().modelName.containsString("iPhone 4") || UIScreen.mainScreen().bounds.size.height == 480.0{
            btnNextHeightConstraint.constant = 45
            is45 = true

        }
        switch pageIndex {
        case 0:
            btnNext.backgroundColor = UIColor.redColor()
            btnNextWidthConstraint.constant = 60
            btnNext.backgroundColor = UIColor.clearColor()
            btnNext.setTitle("", forState: .Normal)
            btnNext.setImage(UIImage(named: "ic_row_next_instruction"), forState: .Normal)
            if is45 {
                btnNext.imageEdgeInsets = UIEdgeInsetsMake(18, 0, 18, 0)
            }else{
                btnNext.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0)

            }
            break
        case 1:
            btnNext.backgroundColor = UIColor.yellowColor()
            btnNextWidthConstraint.constant = 60
            btnNext.backgroundColor = UIColor.clearColor()
            btnNext.setTitle("", forState: .Normal)
            btnNext.setImage(UIImage(named: "ic_row_next_instruction"), forState: .Normal)
            if is45 {
                btnNext.imageEdgeInsets = UIEdgeInsetsMake(18, 0, 18, 0)
            }else{
                btnNext.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0)
                
            }
            break
        case 2:
            btnNext.backgroundColor = hexStringToUIColor("#fa0000")
            btnNext.setImage(nil, forState: .Normal)
            btnNext.setTitle("GET STARTED", forState: .Normal)
            btnNextWidthConstraint.constant = 240
            btnNext.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)

            break
        default:
            break
        }

        self.view.bringSubviewToFront(btnNext)
        
      


    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK-ButtonAction
    
    @IBAction func pressedNext(sender: AnyObject) {
//        guard let curIndex = index else{return}
//        delegate?.didNextGuideViewAtIndex(curIndex)
    }
    func actionNext(sender:UIButton){
        print("pressedNext")
        guard let curIndex = index else{return}
        delegate?.didNextGuideViewAtIndex(curIndex)
    }
}