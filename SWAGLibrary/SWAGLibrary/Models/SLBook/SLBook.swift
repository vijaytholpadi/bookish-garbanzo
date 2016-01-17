//
//  SLBook.swift
//  SWAGLibrary
//
//  Created by Vijay Tholpadi on 1/17/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation

class SLBook: NSObject {
    
    var title : String?
    var author : String?
    var category : String?
    var publisher : String?
    var lastCheckedOutDate : String?
    var lastCheckedOutBy : String?
    var urlString : String?
    
    override init() {
        super.init()
    }
    
    init(dictionary: NSDictionary) {
        
    }
    
    class func getBookArrayFromRawArray(rawArray:[[String:AnyObject]]) -> [SLBook] {
        
        var booksArray : [SLBook] = Array()
        
            for item in rawArray {
                let book : SLBook = SLBook.init()
                book.title = item["title"] as? String
                book.author = item["author"] as? String
                book.category = item["categories"] as? String
                book.publisher = item["publisher"] as? String
                book.lastCheckedOutDate = item["lastCheckedOut"] as? String
                book.lastCheckedOutBy = item["lastCheckedOutBy"] as? String
                book.urlString = item["url"] as? String
                
                booksArray.append(book)
            }
        return booksArray
    }
}