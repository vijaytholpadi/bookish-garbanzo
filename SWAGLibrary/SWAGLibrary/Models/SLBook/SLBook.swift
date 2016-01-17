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
    
    class func getBookArrayFromRawArray(rawArray:Array<[String:String]>) -> [SLBook] {
        
        var booksArray : [SLBook] = Array()
        
        for item in rawArray {
            let book : SLBook = SLBook.init()
            book.title = item["title"]
            book.author = item["author"]
            book.category = item["categories"]
            book.publisher = item["publisher"]
            book.lastCheckedOutDate = item["lastCheckedOut"]
            book.lastCheckedOutBy = item["lastCheckedOutBy"]
            book.urlString = item["url"]

            booksArray.append(book)
        }
        return booksArray
    }
}