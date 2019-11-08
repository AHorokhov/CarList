//
//  Car_listTests.swift
//  Car listTests
//
//  Created by Alexey Horokhov on 04.11.2019.
//  Copyright © 2019 Alexey Horokhov. All rights reserved.
//

import XCTest
import Foundation
@testable import Car_list

class TestsHelper {

    static func encode(_ json: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: json, options: [])
    }

}

public func XCTAssertNoThrow<T>(_ expression: @autoclosure () throws -> T, assignTo ref: inout T?, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssertNoThrow(ref = try expression(), message, file: file, line: line)
}

class Car_listTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
    }

    func testDecode() {
        let data = TestsHelper.encode(["address":"Grosse Reichenstraße 7, 20457 Hamburg",
                                       "coordinates": [9.99622, 53.54847, 0],
                                       "engineType": "CE",
                                       "exterior": "UNACCEPTABLE",
                                       "fuel": 45,
                                       "interior": "GOOD",
                                       "name": "HH-GO8480",
                                       "vin":"WME4513341K412697"])

        var vehicle: Vehicle?
        XCTAssertNoThrow(try Vehicle.decode(data: data), assignTo: &vehicle)

        XCTAssertEqual(vehicle?.fuelAmount, 45)
        XCTAssertEqual(vehicle?.exterior, "UNACCEPTABLE")
    }

}
