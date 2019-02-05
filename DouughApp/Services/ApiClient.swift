//
//  ApiClient.swift
//  DouughApp
//
//  Created by raman singh on 18/01/19.
//  Copyright © 2019 raman singh. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

protocol serviceResponse {
    var result:Data{ get set }
}

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

protocol ServiceManager {
    func requestService(apiRequest: APIRequest) -> Observable<serviceResponse>
}

class DataResponse:serviceResponse{
    var result: Data
    init(result:Data) {
        self.result = result
    }
}

class APIClient:ServiceManager{
    func requestService(apiRequest: APIRequest) -> Observable<serviceResponse> {
        return Observable<serviceResponse>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let a:serviceResponse = DataResponse(result: data!)
                observer.onNext(a)
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private let baseURL = URL(string: "https://gist.githubusercontent.com/douughios/f3c382f543a303984c72abfc1d930af8/raw/5e6745333061fa010c64753dc7a80b3354ae324e/test-users.json")!
    
    func send(apiRequest: APIRequest) -> Observable<serviceResponse> {
        return Observable<serviceResponse>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let a:serviceResponse = DataResponse(result: data!)
                observer.onNext(a)
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}


