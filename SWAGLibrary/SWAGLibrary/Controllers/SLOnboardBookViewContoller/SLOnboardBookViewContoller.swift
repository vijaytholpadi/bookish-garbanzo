//
//  SLOnboardBookViewContoller.swift
//  SWAGLibrary
//
//  Created by Vijay Tholpadi on 1/17/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation
import UIKit

protocol SLOnabordBookDelegate{
    func refreshBooks()
}

class SLOnboardBookViewContoller: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var publisherTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    var delegate: SLOnabordBookDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let bookListNavVC = presentingViewController
        let bookListVC = bookListNavVC!.childViewControllers.first as! SLBookListViewController
        delegate = bookListVC
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        if areAnyfieldFilled() {
            let unsavedChangesAlertController = UIAlertController(title: "Uh-oh!", message: "There are unsaved changes. Do you want to discard them?", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Destructive, handler: { (alertAction: UIAlertAction) -> Void in
                self.dismissViewController()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
            unsavedChangesAlertController.addAction(cancelAction)
            unsavedChangesAlertController.addAction(okAction)
            
            presentViewController(unsavedChangesAlertController, animated: true, completion: nil)
        } else {
            dismissViewController()
        }
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        if areMandatoryFieldsEmpty() {
            showInsufficientDetailsAlert()
        } else {
            addBook()
        }
    }
    
    func addBook() {
        VTNetworkingHelper.sharedInstance().performRequestWithPath(SLNetworkRoutes.postAddABook(), withAuth: true, forMethod: "POST", withRequestJSONSerialized: true, withParams: SLNetworkParams.postAddABookParamsWithAuthor(self.authorTextField.text!, category: self.categoriesTextField.text!, title: self.titleTextField.text!, publisher: self.publisherTextField.text!)) { (response:VTNetworkResponse!) -> Void in
            if response.isSuccessful {
                [self.delegate?.refreshBooks()]
                self.dismissViewController()
            } else {
                
            }
        }
    }
    
    func areMandatoryFieldsEmpty() -> Bool {
        return ((titleTextField.text?.isEmpty)! || (authorTextField.text?.isEmpty)!)
    }
    
    func areAnyfieldFilled() -> Bool {
        return !(titleTextField.text?.isEmpty)! || !(authorTextField.text?.isEmpty)! || !(publisherTextField.text?.isEmpty)! || !(categoriesTextField.text?.isEmpty)!
    }
    
    func showInsufficientDetailsAlert() {
        let insufficientDetailsAlertController = UIAlertController(title: "Error", message: "Title and Author fields are mandatory", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        insufficientDetailsAlertController.addAction(okAction)
        
        presentViewController(insufficientDetailsAlertController, animated: true, completion: nil)
    }
    
    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}