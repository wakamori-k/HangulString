//
//  UnicodeTests.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/05.
//

import XCTest
@testable import HangulString

final class UnicodeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsHangulSyllable() throws {
        // 가
        XCTAssertTrue(Unicode.Scalar(0xAC00)!.isHangulSyllable())
        // 힣
        XCTAssertTrue(Unicode.Scalar(0xD7A3)!.isHangulSyllable())

        // Error cases
        XCTAssertFalse(Unicode.Scalar(0xAC00 - 1)!.isHangulSyllable())
        XCTAssertFalse(Unicode.Scalar(0xD7A3 + 1)!.isHangulSyllable())
    }

    func testIsHangulJamo() throws {
        XCTAssertTrue(Unicode.Scalar(0x1100)!.isHangulJamoInitialConsonant())
        XCTAssertTrue(Unicode.Scalar(0x1112)!.isHangulJamoInitialConsonant())
        XCTAssertFalse(Unicode.Scalar(0x1100 - 1)!.isHangulJamoInitialConsonant())
        XCTAssertFalse(Unicode.Scalar(0x1112 + 1)!.isHangulJamoInitialConsonant())

        XCTAssertTrue(Unicode.Scalar(0x1161)!.isHangulJamoVowel())
        XCTAssertTrue(Unicode.Scalar(0x1175)!.isHangulJamoVowel())
        XCTAssertFalse(Unicode.Scalar(0x1161 - 1)!.isHangulJamoVowel())
        XCTAssertFalse(Unicode.Scalar(0x1175 + 1)!.isHangulJamoVowel())

        XCTAssertTrue(Unicode.Scalar(0x11A8)!.isHangulJamoFinalConsonant())
        XCTAssertTrue(Unicode.Scalar(0x11C2)!.isHangulJamoFinalConsonant())
        XCTAssertFalse(Unicode.Scalar(0x11A8 - 1)!.isHangulJamoFinalConsonant())
        XCTAssertFalse(Unicode.Scalar(0x11C2 + 1)!.isHangulJamoFinalConsonant())
    }
}
