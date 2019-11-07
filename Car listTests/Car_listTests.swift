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

/// Helpers for tests
class TestsHelper {

    static var bundle: Bundle {
        return Bundle(for: TestsHelper.self)
    }

    static func jsonURL(_ fileName: String) -> URL? {
        return bundle.url(forResource: fileName, withExtension: "json")
    }

    static func encode(_ json: [String: Any]) -> Data {
        // swiftlint:disable:next force_try
        return try! JSONSerialization.data(withJSONObject: json, options: [])
    }

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
        self.measure {
            // Put the code you want to measure the time of here.
        }
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

        XCTAssertNoThrow(try Vehicle.decode(data: data))
    }

}
