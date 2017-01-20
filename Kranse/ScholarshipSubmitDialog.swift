//
//  ScholarshipSubmitDialog.swift
//  Kranse
//
//  Created by macbook on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
class ScholarshiSubmitDialog: BaseViewController {
    var delegate: DiscardDialogDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(backToIntroView), userInfo: nil, repeats: false)
    }
    func backToIntroView(){
        self.dismissViewControllerAnimated(true) { 
            self.delegate?.didSelectCancel()
        }
        
    }
    
}