//
//  KainViewController.swift
//  kainmanager
//
//  Created by Buyaka on 1/22/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class KainViewController : UIViewController {
    
    @IBOutlet weak var txtID: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPosition: UITextField!
    
    var kain:Kain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (kain != nil) {
            txtID.text = kain.id
            txtName.text = kain.name
            txtPosition.text = kain.position
        }
    }
    
    @IBAction func doAdd(sender: AnyObject) {
        var obj = Kain()
        var prms = ["name":txtName.text, "position":txtPosition.text]
        DynasHelper.sharedInstance.showActivityIndicator(self.view)
        Dynas.sharedInstance.saveData(obj, params: prms, completion: { (cdata, cerror) -> Void in
            DynasHelper.sharedInstance.hideActivityIndicator(self.view)
            if cerror == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                DynasHelper.sharedInstance.displayAlertMessage("エラー", alertDescription: cerror.description)
            }
        })
    }
    
    @IBAction func doUpdate(sender: AnyObject) {
        var obj = Kain()
        var prms = ["name":txtName.text, "position":txtPosition.text, "id":txtID.text]
        DynasHelper.sharedInstance.showActivityIndicator(self.view)
        Dynas.sharedInstance.updateData(obj, params: prms, completion: { (cdata, cerror) -> Void in
            DynasHelper.sharedInstance.hideActivityIndicator(self.view)
            if cerror == nil {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                DynasHelper.sharedInstance.displayAlertMessage("エラー", alertDescription: cerror.description)
            }
        })
    }
    
}

