import Foundation

import XCTest
@testable import HangulString


final class StringTests: XCTestCase {
    
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
        XCTAssertEqual("あいう".romanized(), "あ い う")
        XCTAssertEqual("a".romanized(), "a")
        XCTAssertEqual("abc".romanized(), "a b c")
        XCTAssertEqual("#".romanized(), "#")
        XCTAssertEqual("#!?".romanized(), "# ! ?")
    }
    
}