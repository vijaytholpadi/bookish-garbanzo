//
//  SLBook.swift
//  SWAGLibrary
//
//  Created by Vijay Tholpadi on 1/17/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation

class SLBook: NSObject {
    
    var title : String
    var author : String
    var category : String?
    var publisher : String?
    var lastCheckedOutDate : String?
    var lastCheckedOutBy : String?
    var urlString : String?
    
    init(title: String, author: String) {
        self.title = title
        self.author = author
    }
    
    class func getBookArrayFromRawArray(rawArray:[[String:AnyObject]]) -> [SLBook] {
        
        var booksArray : [SLBook] = Array()
            for item in rawArray {
                let book : SLBook = SLBook.init(title: (item["title"] as? String)!, author: (item["author"] as? String)!)
            
                book.publisher = item["publisher"] as? String
                
                if let category = item["categories"]{
                    book.category = category as? String
                }
                
                if let lastCheckedOutDate = item["lastCheckedOut"]{
                    book.lastCheckedOutDate = lastCheckedOutDate as? String
                }
                
                if let lastCheckedOutBy = item["lastCheckedOutBy"]{
                    book.lastCheckedOutBy = lastCheckedOutBy as? String
                }

                book.urlString = item["url"] as? String
                booksArray.append(book)
            }
        return booksArray
    }
    
    func updateCheckedOutDetailsWithDetails(book : [String:AnyObject]) {
        if let lastCheckedOutDate = book["lastCheckedOut"]{
            self.lastCheckedOutDate = lastCheckedOutDate as? String
        }
        
        if let lastCheckedOutBy = book["lastCheckedOutBy"]{
            self.lastCheckedOutBy = lastCheckedOutBy as? String
        }
    }
}