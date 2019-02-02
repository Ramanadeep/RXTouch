//
//  UsersViewModel.swift
//  DouughApp
//
//  Created by raman singh on 17/01/19.
//  Copyright © 2019 raman singh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper
import ObservableArray_RxSwift

class UserViewModel{
    //let users : [User]
    var disposeableBag = DisposeBag()
    let apiRequest = UsersServiceRequest()
    let client = APIClient()
    let value = PublishSubject<[UserMap]>()
    var newValue = ObservableArray<UserMap>()
    let valueT = PublishSubject<Employees>()
    
    init() {
        getUsers()
    }
    
    func getUsers() {
        let serviceObserver = self.client.send(apiRequest: self.apiRequest)
        _ = serviceObserver.subscribe(onNext: { res in
            print("SUCCESS VIEWMODEL ----> \(res)")
            do {
                let result = try JSONSerialization.jsonObject(with: res.result, options: []) as? [[String:Any]]
                if let theJSONData = try? JSONSerialization.data(
                    withJSONObject: result ?? [],
                    options: []) {
                    let theJSONText = String(data: theJSONData,
                                             encoding: .ascii)
                    let usersArray = Mapper<UserMap>().mapArray(JSONString: theJSONText!)
                    self.newValue.appendContentsOf(usersArray ?? [])
                }
            } catch {
                self.value.onError(error)
            }
        }, onError: { error in
           self.value.onError(error)
        }, onCompleted: {
            print("Completed")
        }) {
            print("Disposed")
            }.disposed(by: self.disposeableBag)
    }
    
    func sortUsersByFirstName() {
        let userSortedArray = newValue.sorted{ $0.firstName! < $1.firstName! }
        newValue.removeAll()
        newValue.appendContentsOf(userSortedArray )
    }
    
    func sortUsersByLastName() {
        let userSortedArray = newValue.sorted{ $0.lastName! < $1.lastName! }
        newValue.removeAll()
        newValue.appendContentsOf(userSortedArray)
    }
    
    func sortUsersByID() {
        let userSortedArray = newValue.sorted{ $0.id! < $1.id! }
        newValue.removeAll()
        newValue.appendContentsOf(userSortedArray)
    }
}
