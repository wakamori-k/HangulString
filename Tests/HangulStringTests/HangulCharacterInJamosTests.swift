//
//  HangulCharacterInJamosTests.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/12.
//

import XCTest
@testable import HangulString
final class HangulCharacterInJamosTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        do {
            let c = HangulCharacterInJamos(initialConsonant: [.hieut], vowel: .a)
            XCTAssertEqual(c.initialConsonant, [.hieut])
            XCTAssertEqual(c.vowel, .a)
            XCTAssertEqual(c.finalConsonant, [])
        }
        do {
            let c = HangulCharacterInJamos(initialConsonant: [.giyeok, .giyeok], vowel: .i, finalConsonant: [.siot])
            XCTAssertEqual(c.initialConsonant, [.giyeok, .giyeok])
            XCTAssertEqual(c.vowel, .i)
            XCTAssertEqual(c.finalConsonant, [.siot])
        }
    }
}
