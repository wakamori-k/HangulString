import Foundation

import XCTest
@testable import HangulString

final class StringTests: XCTestCase {

    func testRomanized() {
        XCTAssertEqual("안녕하세요".romanized(), "an nyeong ha se yo")

        XCTExpectFailure("Expected failures")
        XCTAssertEqual("안녕하세요?".romanized(), "an nyeong ha se yo?")
        XCTAssertEqual("안녕하세요.".romanized(), "an nyeong ha se yo.")

    }

    func testRomanized_separator() {
        XCTAssertEqual("아".romanized(), "a")
        XCTAssertEqual("아야우".romanized(), "a ya u")

        XCTAssertEqual("아".romanized(separator: "-"), "a")
        XCTAssertEqual("아".romanized(separator: "---"), "a")

        XCTAssertEqual("아야우".romanized(separator: "-"), "a-ya-u")
        XCTAssertEqual("아야우".romanized(separator: "---"), "a---ya---u")
    }

    func testRomanized_nonHangul() {
        XCTAssertEqual("あ".romanized(), "あ")
        XCTAssertEqual("a".romanized(), "a")
        XCTAssertEqual("#".romanized(), "#")

        XCTExpectFailure("Expected failures")
        XCTAssertEqual("あいう".romanized(), "あいう")
        XCTAssertEqual("abc".romanized(), "abc")
        XCTAssertEqual("#!?".romanized(), "#!?")
    }

}
