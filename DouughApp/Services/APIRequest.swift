//
//  APIRequest.swift
//  DouughApp
//
//  Created by raman singh on 18/01/19.
//  Copyright © 2019 raman singh. All rights reserved.
//

import Foundation

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        let request = URLRequest(url:baseURL)
        return request
    }
}
