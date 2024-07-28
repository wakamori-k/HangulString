import Foundation

import XCTest
@testable import HangulString

final class StringTests: XCTestCase {

    func testRomanized() {
        XCTAssertEqual("안녕하세요".romanized(), "an nyeong ha se yo")

        XCTAssertEqual("안녕하세요?".romanized(), "an nyeong ha se yo?")
        XCTAssertEqual("안녕하세요.".romanized(), "an nyeong ha se yo.")
        XCTAssertEqual("좋은 하루 보내세요".romanized(), "joh eun ha ru bo nae se yo")
    }

    func testRomanized_separator() {
        XCTAssertEqual("아".romanized(), "a")
        XCTAssertEqual("아야우".romanized(), "a ya u")

        XCTAssertEqual("아".romanized(separator: "-"), "a")
        XCTAssertEqual("아".romanized(separator: "---"), "a")

        XCTAssertEqual("아야우".romanized(separator: "-"), "a-ya-u")
        XCTAssertEqual("아야우".romanized(separator: "---"), "a---ya---u")

        XCTAssertEqual("좋은 하루 보내세요".romanized(separator: ""), "joheun haru bonaeseyo")
        XCTAssertEqual("좋은 하루 보내세요".romanized(separator: "-"), "joh-eun ha-ru bo-nae-se-yo")
    }

    func testRomanized_nonHangul() {
        XCTAssertEqual("あ".romanized(), "あ")
        XCTAssertEqual("a".romanized(), "a")
        XCTAssertEqual("#".romanized(), "#")

        XCTAssertEqual("あいう".romanized(), "あいう")
        XCTAssertEqual("abc".romanized(), "abc")
        XCTAssertEqual("#!?".romanized(), "#!?")
    }
    
    func testKatakanized() {
        XCTAssertEqual("안녕하세요".katakanize(), "アンニョンハセヨ")

        XCTAssertEqual("안녕하세요?".katakanize(), "アンニョンハセヨ?")
        XCTAssertEqual("안녕하세요.".katakanize(), "アンニョンハセヨ.")

        XCTAssertEqual("좋은 하루 보내세요".katakanize(), "チョッウン ハル ポネセヨ")
        XCTAssertEqual("안녕히 계세요".katakanize(), "アンニョンヒ ケセヨ")
        XCTAssertEqual("잘 지냈어요?".katakanize(), "チャ(ル) チネッオヨ?")
    }

    func testKatakanized_nonHangul() {
        XCTAssertEqual("あ".katakanize(), "あ")
        XCTAssertEqual("a".katakanize(), "a")
        XCTAssertEqual("#".katakanize(), "#")

        XCTAssertEqual("あいう".katakanize(), "あいう")
        XCTAssertEqual("abc".katakanize(), "abc")
        XCTAssertEqual("#!?".katakanize(), "#!?")
    }

}
