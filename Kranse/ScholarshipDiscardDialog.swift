//
//  ScholarDiscardDialog.swift
//  Kranse
//
//  Created by macbook on 9/20/16.
//  Copyright © 2016 itv. All rights reserved.
//

import Foundation
protocol DiscardDialogDelegate {
    func didSelectOK()
    func didSelectCancel()
}
class ScholarDiscardDialog: UIViewController {
    
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var btnDiscard: UIButton!
    var delegate:DiscardDialogDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pressedSubmit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            self.delegate?.didSelectOK()

        }
    }
    @IBAction func pressedCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true){
           self.delegate?.didSelectCancel()

        }

    }
    
}