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
        
        self.title = "Books"
        tableView.dataSource = self;
        tableView.delegate = self;
        
        self.setupNavigationBarButtons()
        self.fetchAllBooks()
    }
    
    internal func setupNavigationBarButtons() {
        let addButton :UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonPressed")
        self.navigationItem.leftBarButtonItem = addButton
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
        let onboardBookVC = self.storyboard?.instantiateViewControllerWithIdentifier("SLOnboardBookViewContoller") as! SLOnboardBookViewContoller
        presentViewController(onboardBookVC, animated: true, completion: nil)
    }
    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksArray.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentBook : SLBook = self.booksArray[indexPath.row]
        
        let tableViewcell = tableView.dequeueReusableCellWithIdentifier("booksTableViewCell")! as UITableViewCell
        tableViewcell.textLabel?.text = currentBook.title
        tableViewcell.detailTextLabel?.text = currentBook.author
        return tableViewcell;
    }
    
    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentBook : SLBook = self.booksArray[indexPath.row]
        
        let bookDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("SLBookDetailViewController") as! SLBookDetailViewController
        bookDetailVC.bookInContext = currentBook
        self.navigationController?.pushViewController(bookDetailVC, animated: true)
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func refreshBooks() {
        self.fetchAllBooks()
    }
}