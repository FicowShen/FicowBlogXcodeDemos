//
//  ViewModelTests.swift
//  XCTestDemoTests
//
//  Created by Ficow on 2020/9/28.
//  Copyright © 2020 ficow. All rights reserved.
//

import XCTest
@testable import XCTestDemo // 请勿忘记导入待测试的模块，而且需要加上 @testable 以提升模块的访问控制级别

class ViewModelTests: XCTestCase {

    // 可以复用的逻辑可以抽取出来
    var viewModel: ViewModel!
    var mockServiceProvider: MockServiceProvider!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockServiceProvider = MockServiceProvider()
        viewModel = ViewModel(serviceProvider: mockServiceProvider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginFailure() {
        mockServiceProvider.error = Service.ServiceError.wrongAccountOrPassword
        viewModel.login(account: "ficow", password: "1")

        // 登录失败时必须有错误
        XCTAssertEqual(viewModel.loginError, Service.ServiceError.wrongAccountOrPassword, "should login fail with wrongAccountOrPassword error")

    }

    func testLoginSuccess() {
        mockServiceProvider.result = UserInfo(id: 1, name: "Ficow Shen")
        viewModel.login(account: "ficow", password: "1234")

        // 不再需要异步测试

        XCTAssertEqual(viewModel.userInfo?.id, 1, "wrong user id")
        XCTAssertEqual(viewModel.userInfo?.name, "Ficow Shen", "wrong user name")
    }
}

class MockServiceProvider: ServiceProvider {

    var result: UserInfo?
    var error: Service.ServiceError?

    func login(account: String, password: String, completion: @escaping (Result<UserInfo, Service.ServiceError>) -> Void) {
        // ViewModel 的测试不再依赖于网络层
        if let result = result {
            completion(.success(result))
        } else if let error = error {
            completion(.failure(error))
        } else {
            fatalError("should set result or error for MockServiceProvider")
        }
    }
}
