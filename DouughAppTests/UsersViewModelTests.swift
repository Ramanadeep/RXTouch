//
//  UsersViewModelTests.swift
//  DouughAppTests
//
//  Created by raman singh on 02/02/19.
//  Copyright © 2019 raman singh. All rights reserved.
//

import XCTest
import RxSwift
@testable import DouughApp
@testable import Mocker

/// Contains all available Mocked data.
public final class MockedData {
    public static let botAvatarImageFileUrl: URL = Bundle(for: MockedData.self).url(forResource: "wetransfer_bot_avatar", withExtension: "png")!
    public static let exampleJSON: URL = Bundle(for: MockedData.self).url(forResource: "example", withExtension: "json")!
    public static let redirectGET: URL = Bundle(for: MockedData.self).url(forResource: "Resources/sample-redirect-get", withExtension: "data")!
}

internal extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}

class UsersViewModelTests: XCTestCase {
    let disposeBag = DisposeBag()
    var sessionUnderTest: URLSession!
    var sut: UserViewModel?
    override func setUp() {
        //sut = UserViewModel()\
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func testUsersResult() {
        var testUserValue = UserMap()
        testUserValue.firstName = "Bob"
        testUserValue.lastName = "Ong"
        testUserValue.id = 1
        testUserValue.email = "bob@ong.com"
        sut = UserViewModel(serviceManager: MockAPIClient())
        let userObservable = sut?.newValue.rx_elements().observeOn(MainScheduler.instance)
        _  = userObservable?.subscribe(onNext: { users in
            if let user = users.first{
                XCTAssertEqual(user, testUserValue)
            }
            print("Users in TEST-->",users)
        }, onError: { error in
            //
        }, onCompleted: {
            //
        }) {
            //Disposed
        }
        sut?.getUsers()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class MockAPIClient:XCTestCase, ServiceManager{
    
    func requestService(apiRequest: APIRequest) -> Observable<serviceResponse> {
        return Observable<serviceResponse>.create { observer in
            let expectation = self.expectation(description: "Data request should succeed")
            let originalURL = URL(string: "https://gist.githubusercontent.com/douughios/f3c382f543a303984c72abfc1d930af8/raw/5e6745333061fa010c64753dc7a80b3354ae324e/test-users.json")!
            
            let mock = Mock(url: originalURL, contentType: .json, statusCode: 200, data: [
                .get : MockedData.exampleJSON.data // Data containing the JSON response
                ])
            mock.register()
            
            URLSession.shared.dataTask(with: originalURL) { (data, _, _) in
                
                guard let data = data else {
                    XCTFail("Wrong data response")
                    expectation.fulfill()
                    return
                }
                let a:serviceResponse = DataResponse(result: data)
                observer.onNext(a)
                observer.onCompleted()
                expectation.fulfill()
                }.resume()
            
            self.waitForExpectations(timeout: 35.0, handler: nil)
            
            return Disposables.create {
                //task.cancel()
            }
        }
    }
}
