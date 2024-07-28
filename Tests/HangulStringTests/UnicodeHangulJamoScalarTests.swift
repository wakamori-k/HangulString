//
//  UnicodeHangulJamoScalarTests.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/06.
//

import XCTest
@testable import HangulString

final class UnicodeHangulJamoScalarTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        // Initial consonants
        do {
            let scalar = try UnicodeHangulJamoScalar(UnicodeScalar(0x1100)!)
            XCTAssertEqual(scalar.value, 0x1100)
        }
        do {
            let scalar = try UnicodeHangulJamoScalar(UnicodeScalar(0x1112)!)
            XCTAssertEqual(scalar.value, 0x1112)
        }
        // Vowels
        do {
            let scalar = try UnicodeHangulJamoScalar(UnicodeScalar(0x1161)!)
            XCTAssertEqual(scalar.value, 0x1161)
        }
        do {
            let scalar = try UnicodeHangulJamoScalar(UnicodeScalar(0x1175)!)
            XCTAssertEqual(scalar.value, 0x1175)
        }
        // Final consonants
        do {
            let scalar = try UnicodeHangulJamoScalar(UnicodeScalar(0x11A8)!)
            XCTAssertEqual(scalar.value, 0x11A8)
        }
        do {
            let scalar = try UnicodeHangulJamoScalar(UnicodeScalar(0x11C2)!)
            XCTAssertEqual(scalar.value, 0x11C2)
        }
    }

    func testInit_error() throws {
        // Initial consonants
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(UnicodeScalar(0x1100 - 1)!)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidUnicodeScalar)
        }
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(UnicodeScalar(0x1112 + 1)!)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidUnicodeScalar)
        }
        // Vowels
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(UnicodeScalar(0x1161 - 1)!)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidUnicodeScalar)
        }
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(UnicodeScalar(0x1175 + 1)!)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidUnicodeScalar)
        }
        // Final consonants
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(UnicodeScalar(0x11A8 - 1)!)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidUnicodeScalar)
        }
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(UnicodeScalar(0x11C2 + 1)!)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidUnicodeScalar)
        }
    }

    func testInit_fromJamos() throws {
        // Initial consonants
        do {
            let scalar = try UnicodeHangulJamoScalar(jamos: [.giyeok], firstConsonant: true)
            XCTAssertEqual(scalar.value, 0x1100)
        }
        do {
            let scalar = try UnicodeHangulJamoScalar(jamos: [.giyeok, .giyeok], firstConsonant: true)
            XCTAssertEqual(scalar.value, 0x1101)
        }
        // Vowels
        do {
            let scalar = UnicodeHangulJamoScalar(jamos: [.a])
            XCTAssertEqual(scalar.value, 0x1161)
        }
        do {
            let scalar = UnicodeHangulJamoScalar(jamos: [.i])
            XCTAssertEqual(scalar.value, 0x1175)
        }
        // Final consonants
        do {
            let scalar = try UnicodeHangulJamoScalar(jamos: [.giyeok], firstConsonant: false)
            XCTAssertEqual(scalar.value, 0x11A8)
        }
        do {
            let scalar = try UnicodeHangulJamoScalar(jamos: [.giyeok, .giyeok], firstConsonant: false)
            XCTAssertEqual(scalar.value, 0x11A9)
        }
    }

    func testInit_fromJamos_error() throws {
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(jamos: [], firstConsonant: true)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidJamoSequence)
        }
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(jamos: [.giyeok, .siot], firstConsonant: true)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidJamoSequence)
        }

        XCTAssertThrowsError(try UnicodeHangulJamoScalar(jamos: [], firstConsonant: false)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidJamoSequence)
        }
        XCTAssertThrowsError(try UnicodeHangulJamoScalar(jamos: [.digeut, .digeut], firstConsonant: false)) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidJamoSequence)
        }
    }

    func testIsHangulJamoElement() throws {
        // Initial consonants
        XCTAssertTrue(try UnicodeHangulJamoScalar(UnicodeScalar(0x1100)!).isHangulJamoInitialConsonant())
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x1100)!).isHangulJamoVowel())
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x1100)!).isHangulJamoFinalConsonant())

        XCTAssertTrue(try UnicodeHangulJamoScalar(UnicodeScalar(0x1112)!).isHangulJamoInitialConsonant())
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x1112)!).isHangulJamoVowel())
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x1112)!).isHangulJamoFinalConsonant())

        // Vowels
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x1161)!).isHangulJamoInitialConsonant())
        XCTAssertTrue(try UnicodeHangulJamoScalar(UnicodeScalar(0x1161)!).isHangulJamoVowel())
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x1161)!).isHangulJamoFinalConsonant())

        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x1175)!).isHangulJamoInitialConsonant())
        XCTAssertTrue(try UnicodeHangulJamoScalar(UnicodeScalar(0x1175)!).isHangulJamoVowel())
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x1175)!).isHangulJamoFinalConsonant())

        // Final consonants
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x11A8)!).isHangulJamoInitialConsonant())
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x11A8)!).isHangulJamoVowel())
        XCTAssertTrue(try UnicodeHangulJamoScalar(UnicodeScalar(0x11A8)!).isHangulJamoFinalConsonant())

        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x11C2)!).isHangulJamoInitialConsonant())
        XCTAssertFalse(try UnicodeHangulJamoScalar(UnicodeScalar(0x11C2)!).isHangulJamoVowel())
        XCTAssertTrue(try UnicodeHangulJamoScalar(UnicodeScalar(0x11C2)!).isHangulJamoFinalConsonant())
    }
}
