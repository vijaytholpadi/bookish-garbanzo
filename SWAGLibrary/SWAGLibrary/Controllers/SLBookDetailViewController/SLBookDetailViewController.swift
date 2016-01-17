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
     
        self.setupBookDetails()
        self.setupNavigationBarButtons()
    }
    
    func setupBookDetails() {
        self.title = self.bookInContext?.title
        self.bookTitleLabel.text = self.bookInContext?.title
        self.bookAuthorLabel.text = self.bookInContext?.author
        self.bookPublisherLabel.text = String("Publisher: " + (self.bookInContext?.publisher)!)
        
        if let category = self.bookInContext?.category{
            self.bookCategoriesLabel.text = String("Tags: " + category)
        }
        if let lastCheckedOutBy = self.bookInContext?.lastCheckedOutBy, lastCheckedOutDate = self.bookInContext?.lastCheckedOutDate{
            self.bookLastCheckedOutLabel.text = (String("Last Checkout by: " + lastCheckedOutBy + " @ " + lastCheckedOutDate))
        }
    }
    
    func setupNavigationBarButtons(){
        let sharebutton :UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonPressed")
        self.navigationItem.rightBarButtonItem = sharebutton
    }
    
    func shareButtonPressed(){
        let message = String("Check this book out at the SWAGLibrary: " + (self.bookInContext?.title)!)
        let bookURL = String(SLNetworkRoutes.rootURL + (self.bookInContext?.urlString)!)
        let activityVC = UIActivityViewController(activityItems: [message, bookURL], applicationActivities: nil)
        presentViewController(activityVC, animated: true) { () -> Void in
        }
    }
    
    @IBAction func checkoutButtonPressed(sender: AnyObject) {
        let checkoutAlertController = UIAlertController(title: "Almost there", message: "Please enter your name", preferredStyle: .Alert)
        checkoutAlertController.addTextFieldWithConfigurationHandler { (textfield:UITextField) -> Void in
            textfield.placeholder = "Name"
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
        
        checkoutAlertController.addAction(cancelAction)
        checkoutAlertController.addAction(okAction)
        presentViewController(checkoutAlertController, animated: true, completion: nil)
    }
}