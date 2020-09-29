//
//  XCTestDemoTests.swift
//  XCTestDemoTests
//
//  Created by Ficow on 2020/9/27.
//  Copyright © 2020 ficow. All rights reserved.
//

// 导入 XCTest 测试框架
import XCTest

// 导入需要测试的模块
@testable import XCTestDemo

// 一个测试用例，可能包含多个测试方法
class XCTestDemoTests: XCTestCase {

    // 在这个测试用例类开始执行测试方法前执行，并且只执行一次
    override class func setUp() {

    }

    // 在这个测试用例类中所有的测试方法执行结束后执行，并且只执行一次
    override class func tearDown() {

    }

    // 在每个测试方法启动前执行，用于配置每个测试用例
    override func setUpWithError() throws {

    }

    // 在每个测试方法执行结束后执行，用于清理
    override func tearDownWithError() throws {

    }

    // 一个功能测试方法（方法名必须以 test 开头）
    func testExample() throws {
        // 您可以使用 XCTAssert 相关方法来验证测试是否产生了正确的结果
//        XCTAssert(false, "It should fail!")
    }

    // 一个性能测试方法（方法名必须以 test 开头）
    func testPerformanceExample() throws {
        self.measure {
            // 把需要测试运行时间的代码添加到这里
            for i in 0...Int(1e4) {
                print(i)
            }
        }
    }

    func testPerformanceExample2() throws {
        self.measure {
            // 把需要测试运行时间的代码添加到这里
            for i in 0...Int(1e4) {
                print(i)
            }
        }
    }
}
