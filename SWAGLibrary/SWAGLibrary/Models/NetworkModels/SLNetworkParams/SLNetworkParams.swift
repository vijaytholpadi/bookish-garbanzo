//
//  SLNetworkParams.swift
//  SWAGLibrary
//
//  Created by Vijay Tholpadi on 1/17/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation

class SLNetworkParams: NSObject {
    ///Class method returning parameters for Add a book API
    class func postAddABookParamsWithAuthor(author : String, category : String, title : String, publisher : String) -> [String: String] {
        return ["author":author, "categories":category, "title":title, "publisher":publisher]
    }
    
    ///Class method returning parameters for update book API
    class func putUpdateBookParamsWithLastCheckedOutName(name : String) -> [String: String] {
        return ["lastCheckedOutBy":name]
    }
}