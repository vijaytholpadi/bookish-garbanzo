//
//  SLBookListViewController.swift
//  SWAGLibrary
//
//  Created by Vijay Tholpadi on 1/17/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation
import UIKit

protocol BookListDelegate {
    func refreshBooks()
}

class SLBookListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SLOnabordBookDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var booksArray: [SLBook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Books"
        tableView.dataSource = self;
        tableView.delegate = self;
        
        setupNavigationBarButtons()
        fetchAllBooks()
    }
    
    internal func setupNavigationBarButtons() {
        let addButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPressed")
        navigationItem.leftBarButtonItem = addButton
        
        let deleteAllButton : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteAllButtonPressed")
        navigationItem.rightBarButtonItem = deleteAllButton
    }
    
    internal func fetchAllBooks() {
        VTNetworkingHelper.sharedInstance().performRequestWithPath(SLNetworkRoutes.getAllBooksAPI(), withAuth: true, withRequestJSONSerialized: true) { (response : VTNetworkResponse!) -> Void in
            if response.isSuccessful {
                self.booksArray = SLBook.getBookArrayFromRawArray(response.data as! [[String : AnyObject]])
                self.tableView.reloadData()
            } else {
                
            }
        }
    }
    
    internal func addButtonPressed() {
        let onboardBookVC = storyboard?.instantiateViewControllerWithIdentifier("SLOnboardBookViewContoller") as! SLOnboardBookViewContoller
        presentViewController(onboardBookVC, animated: true, completion: nil)
    }
    
    internal func deleteAllButtonPressed() {
        let deleteAllConfirmationAlertController = UIAlertController(title: "Warning", message: "Are you sure you want to delete all the books?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (UIAlertAction) -> Void in
            VTNetworkingHelper.sharedInstance().performRequestWithPath(SLNetworkRoutes.deleteAllBooksAPI(), withAuth: true, forMethod: "DELETE", withRequestJSONSerialized: true, withParams: nil) { (response:VTNetworkResponse!) -> Void in
                if response.isSuccessful {
                    self.refreshBooks()
                } else {
                }
            }
        }
        
        deleteAllConfirmationAlertController.addAction(cancelAction)
        deleteAllConfirmationAlertController.addAction(deleteAction)
        presentViewController(deleteAllConfirmationAlertController, animated: true, completion: nil)
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksArray.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentBook : SLBook = booksArray[indexPath.row]
        
        let tableViewcell = tableView.dequeueReusableCellWithIdentifier("booksTableViewCell")! as UITableViewCell
        tableViewcell.textLabel?.text = currentBook.title
        tableViewcell.detailTextLabel?.text = currentBook.author
        return tableViewcell;
    }
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentBook : SLBook = booksArray[indexPath.row]
        
        let bookDetailVC = storyboard?.instantiateViewControllerWithIdentifier("SLBookDetailViewController") as! SLBookDetailViewController
        bookDetailVC.bookInContext = currentBook
        navigationController?.pushViewController(bookDetailVC, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func refreshBooks() {
        fetchAllBooks()
    }
}