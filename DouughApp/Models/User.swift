//
//  User.swift
//  DouughInterviewExercise
//
//  Created by raman singh on 14/01/19.
//  Copyright © 2019 raman singh. All rights reserved.
//

import Foundation
import ObjectMapper

//typealias Employees = [Employee]

class Employees:Codable {
    let employee:[Employee]
}

class Employee: Codable {
    let id: Int
    let firstName, lastName, email: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}

struct UsersArray:Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    var users:[UserMap]?
    
}

struct UserMap:Mappable {
    var id:Int?
    var firstName:String?
    var lastName:String?
    var email:String?
    
    init() {}
    
    init?(map: Map) {
        // check if a required properties exists within the JSON.
        if map.JSON["id"] == nil {
            return nil
        }
        if map.JSON["first_name"] == nil {
            return nil
        }
        if map.JSON["last_name"] == nil {
            return nil
        }
        if map.JSON["email"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        email <- map["email"]
    }
    
}
