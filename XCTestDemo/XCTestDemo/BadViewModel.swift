//
//  BadViewModel.swift
//  XCTestDemo
//
//  Created by Ficow on 2020/9/28.
//  Copyright © 2020 ficow. All rights reserved.
//

import Foundation

// 存储用户信息
struct UserInfo {
    let id: Int
    let name: String
}

// 负责发起网络请求
final class Service {

    enum ServiceError: Error, Equatable {
        case wrongAccountOrPassword
    }

    static let shared = Service()

    func login(account: String, password: String, completion: @escaping (Result<UserInfo, Service.ServiceError>) -> Void) {
        // 实际项目不会这样检查固定值，请勿模仿
        guard account == "ficow" && password == "1234" else {
            completion(.failure(ServiceError.wrongAccountOrPassword))
            return
        }
        // 模拟发起实际的网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(UserInfo(id: 1, name: "Ficow Shen")))
        }
    }
}

// 负责处理页面的业务逻辑
final class ViewModel {

    // 用于检查运行结果
    private(set) var userInfo: UserInfo?
    private(set) var loginError: Service.ServiceError?

    func login(account: String, password: String) {
        // 直接使用了 Service 单例
        Service.shared.login(account: account, password: password) { [weak self] result in
            switch result {
            case .success(let userInfo):
                self?.saveUserInfo(userInfo)
            case .failure(let error):
                self?.showLoginError(error)
            }
        }
    }

    private func saveUserInfo(_ userInfo: UserInfo) {
        self.userInfo = userInfo
    }

    private func showLoginError(_ error: Service.ServiceError) {
        self.loginError = error
    }
}

// 负责处理页面的业务逻辑
final class ViewModel2 {

    // 用于检查运行结果
    private(set) var userInfo: UserInfo?
    private(set) var loginError: Service.ServiceError?

    private let service: Service

    // 任何遵循 ServiceProvider 协议的实例都可以传入
    init(service: Service) {
        self.service = service
    }

    func login(account: String, password: String) {
        // 使用初始化时传入的依赖：serviceProvider
        service.login(account: account, password: password) { [weak self] result in
            switch result {
            case .success(let userInfo):
                self?.saveUserInfo(userInfo)
            case .failure(let error):
                self?.showLoginError(error)
            }
        }
    }

    private func saveUserInfo(_ userInfo: UserInfo) {
        self.userInfo = userInfo
    }

    private func showLoginError(_ error: Service.ServiceError) {
        self.loginError = error
    }
}
