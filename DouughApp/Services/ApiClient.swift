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

class DataResponse:serviceResponse{
    var result: Data
    init(result:Data) {
        self.result = result
    }
}

enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class APIClient{
    
    private let baseURL = URL(string: "https://gist.githubusercontent.com/douughios/f3c382f543a303984c72abfc1d930af8/raw/5e6745333061fa010c64753dc7a80b3354ae324e/test-users.json")!
    
    func sendD<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        return Observable<T>.create { [unowned self] observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
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


