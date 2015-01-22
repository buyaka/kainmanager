//
//  ViewController.swift
//  kainmanager
//
//  Created by Buyaka on 1/22/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "CELL"
    var tableData = Array<Kain>()
    var kainSelected:Kain!
    
    @IBAction func doAdd(sender: AnyObject) {
        kainSelected = nil
        performSegueWithIdentifier("kain_detail", sender: self)
    }
    
    
    @IBAction func doRefresh(sender: AnyObject) {
        reloadData()
    }
    
    @IBAction func doSignout(sender: AnyObject) {
    }
    
    func isLogged() {
        let loginController: SigninViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SinginViewController") as SigninViewController
        if (!DynasHelper.sharedInstance.checkLogin()) {
            self.navigationController?.presentViewController(loginController, animated: true, completion: nil)
        }
    }
    
    /*func checkLogin() {
        // check if user is signed in
        let defaults = NSUserDefaults.standardUserDefaults()
        let loginController: SigninViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SinginViewController") as SigninViewController
        
        // is user is not signed in display controller to sign in or sign up
        if defaults.objectForKey("dynasUserLoggedIn") == nil {
            self.navigationController?.presentViewController(loginController, animated: true, completion: nil)
        } else {
            // check if API token has expired
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let userTokenExpiryDate : NSString? = KeychainAccess.passwordForAccount("Auth_Token_Expiry", service: "KeyChainService")
            let dateFromString : NSDate? = dateFormatter.dateFromString(userTokenExpiryDate!)
            let now = NSDate()
            
            let comparision = now.compare(dateFromString!)
            
            // logout and ask user to sign in again if token is expired
            if comparision != NSComparisonResult.OrderedAscending {
                self.doSignout(self)
            }
            
        }
    }*/
    
    
    func reloadData() {
        DynasHelper.sharedInstance.showActivityIndicator(self.view)
        var model = Kain()
        Dynas.sharedInstance.getDatas(model, filter: "", completion: { (cdata, cerror) -> Void in
            DynasHelper.sharedInstance.hideActivityIndicator(self.view)
            if (cerror == nil) {
                if cdata.count > 0 {
                    self.tableData.removeAll(keepCapacity: true)
                    for element in cdata {
                        var obj = Kain()
                        obj.name = (element as NSDictionary)["name"] as String
                        obj.id = (element as NSDictionary)["id"] as String
                        obj.position = (element as NSDictionary)["position"] as String
                        self.tableData.append(obj)
                    }
                    self.tableView.reloadData()
                }
            } else {
                DynasHelper.sharedInstance.displayAlertMessage("Error", alertDescription: cerror.description)
            }
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isLogged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        kainSelected = tableData[indexPath.row] as Kain
        performSegueWithIdentifier("kain_detail", sender: self)
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        var n : Kain = tableData[indexPath.row] as Kain
        cell.textLabel?.text = n.name
        cell.detailTextLabel?.text = n.position
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var obj = tableData[indexPath.row] as Kain
            var prms = ["id" : obj.id]
            Dynas.sharedInstance.deleteData(obj, params: prms, completion: { (cdata, cerror) -> Void in
                if ( cerror != nil) {
                    DynasHelper.sharedInstance.displayAlertMessage("エラー", alertDescription: cerror.description)
                } else {
                    self.tableData.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier=="kain_detail"{
            var detail = segue.destinationViewController as KainViewController
            detail.kain = kainSelected
        }
    }

}

