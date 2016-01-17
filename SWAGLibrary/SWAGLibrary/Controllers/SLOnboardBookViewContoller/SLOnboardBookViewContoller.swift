//
//  SLOnboardBookViewContoller.swift
//  SWAGLibrary
//
//  Created by Vijay Tholpadi on 1/17/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation
import UIKit

class SLOnboardBookViewContoller: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewController()
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        if self.areMandatoryFieldsEmpty() {
            self.showInsufficientDetailsAlert()
        } else {
            self.addBook()
        }
    }
    
    func addBook() {
        VTNetworkingHelper.sharedInstance().performRequestWithPath(SLNetworkRoutes.postAddABook(), withAuth: true, forMethod: "POST", withRequestJSONSerialized: true, withParams: SLNetworkParams.postAddABookParamsWithAuthor(self.authorTextField.text!, category: self.categoriesTextField.text!, title: self.titleTextField.text!, publisher: self.publisherTextField.text!)) { (response:VTNetworkResponse!) -> Void in
            if response.isSuccessful {
                self.dismissViewController()
            } else {
                
            }
        }
    }
    
    func areMandatoryFieldsEmpty() -> Bool {
        return ((self.titleTextField.text?.isEmpty)! || (self.authorTextField.text?.isEmpty)!)
    }
    
    func showInsufficientDetailsAlert() {
        let insufficientDetailsAlertController = UIAlertController(title: "Error", message: "Title and Author fields are mandatory ", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        insufficientDetailsAlertController.addAction(okAction)
        
        presentViewController(insufficientDetailsAlertController, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}