//
//  UsersServiceRequest.swift
//  DouughApp
//
//  Created by raman singh on 18/01/19.
//  Copyright © 2019 raman singh. All rights reserved.
//

import Foundation

class UsersServiceRequest: APIRequest {
    var method = RequestType.GET
    var path = "search"
    var parameters = [String: String]()
    
//    init(name: String) {
//        parameters["name"] = name
//    }
}

