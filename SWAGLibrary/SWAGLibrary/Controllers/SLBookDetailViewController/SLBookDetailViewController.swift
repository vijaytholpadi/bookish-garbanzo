//
//  SLBookDetailViewController.swift
//  SWAGLibrary
//
//  Created by Vijay Tholpadi on 1/17/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation
import UIKit

class SLBookDetailViewController: UIViewController {
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorLabel: UILabel!
    @IBOutlet weak var bookPublisherLabel: UILabel!
    @IBOutlet weak var bookCategoriesLabel: UILabel!
    @IBOutlet weak var bookLastCheckedOutLabel: UILabel!
    
    var bookInContext : SLBook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detail"
        setupBookDetails()
        setupNavigationBarButtons()
    }
    
    //MARK: - IBAction Methods
    ///IBAction for Checkout Button
    @IBAction func checkoutButtonPressed(sender: AnyObject) {
        let checkoutAlertController = UIAlertController(title: "Almost there", message: "Please enter your name", preferredStyle: .Alert)
        checkoutAlertController.addTextFieldWithConfigurationHandler { (textfield:UITextField) -> Void in
            textfield.placeholder = "Name"
            
            //Adding a target-Action here to detect changes to the Name Textfield to handle the case of empty string
            textfield.addTarget(self, action: "alertControllerTextChanged:", forControlEvents: .EditingChanged)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alertAction:UIAlertAction) -> Void in
        }
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (alertAction:UIAlertAction) -> Void in
            let nameString = checkoutAlertController.textFields?.first?.text
            
            VTNetworkingHelper.sharedInstance().performRequestWithPath(SLNetworkRoutes.putUpdateBookAPIForBookAtURLString(self.bookInContext!.urlString!), withAuth: true, forMethod: "PUT", withRequestJSONSerialized: true, withParams:SLNetworkParams.putUpdateBookParamsWithLastCheckedOutName(nameString!), withCompletionHandler: { (response:VTNetworkResponse!) -> Void in
                if response.isSuccessful {
                    self.bookInContext?.updateCheckedOutDetailsWithDetails(response.data as! [String : AnyObject])
                    self.setupBookDetails()
                } else {
                    
                }
            })
        }
        okAction.enabled = false;
        checkoutAlertController.addAction(cancelAction)
        checkoutAlertController.addAction(okAction)
        presentViewController(checkoutAlertController, animated: true, completion: nil)
    }
    
    //MARK: - Instance Methods
    ///Instance method to setup all the details of the present book in context
    func setupBookDetails() {
        bookTitleLabel.text = self.bookInContext?.title
        bookAuthorLabel.text = self.bookInContext?.author
        bookPublisherLabel.text = String("Publisher: " + (self.bookInContext?.publisher)!)
        
        if let category = self.bookInContext?.category{
            bookCategoriesLabel.text = String("Tags: " + category)
        }
        if let lastCheckedOutBy = self.bookInContext?.lastCheckedOutBy, lastCheckedOutDate = self.bookInContext?.lastCheckedOutDate{
            bookLastCheckedOutLabel.text = (String("Last Checkout by: " + lastCheckedOutBy + " @ " + lastCheckedOutDate))
        }
    }

    ///Instance method to setup NavigationBarButton Items
    func setupNavigationBarButtons(){
        let sharebutton :UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonPressed")
        navigationItem.rightBarButtonItem = sharebutton
    }
    
    //MARK: - Target-Action methods
    ///Target-Action method for Share Button
    func shareButtonPressed(){
        let message = String("Check this book out at the SWAGLibrary: " + (bookInContext?.title)!)
        let bookURL = String(SLNetworkRoutes.rootURL + (bookInContext?.urlString)!)
        let activityVC = UIActivityViewController(activityItems: [message, bookURL], applicationActivities: nil)
        presentViewController(activityVC, animated: true) { () -> Void in
        }
    }

    ///Target-Action method to set the state of the OK Button based on the text in the Name textfield
    func alertControllerTextChanged(sender:AnyObject) {
        let alertTF = sender as! UITextField
        var responder : UIResponder = alertTF
        while !(responder is UIAlertController) {
            responder = responder.nextResponder()!
        }
        let alertController = responder as! UIAlertController
        (alertController.actions[1] as UIAlertAction).enabled = (alertTF.text != "")
    }
}