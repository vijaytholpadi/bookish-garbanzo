//
//  SLNetworkRoutes.swift
//  SWAGLibrary
//
//  Created by Vijay Tholpadi on 1/17/16.
//  Copyright © 2016 TheGeekProjekt. All rights reserved.
//

import Foundation

class SLNetworkRoutes : NSObject {
//MARK: Server URL configuration
    let rootURL: String = "http://prolific-interview.herokuapp.com/568aaa510851c100096d0232";
    
//MARK: Class functions returning route to a particular endpoint
    func getaBookAPIForBookAtURLString(bookURLString : String) -> String {
        return String (self.rootURL + bookURLString)
    }
    
    func updateABookAPIForBookAtURLString(bookURLString : String) -> String {
        return String (self.rootURL + bookURLString)
    }
    
    func deleteABookAPIForBookAtURLString(bookURLString : String) -> String {
        return String (self.rootURL + bookURLString)
    }
    
    func postAddABook() -> String {
        return String (self.rootURL + "/books/")
    }
    
    func getAllBooksAPI() -> String {
        return String (self.rootURL + "/books/")
    }
    
    func deleteAllBooksAPI() -> String {
        return String (self.rootURL + "/clean")
    }
}