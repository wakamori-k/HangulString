import XCTest
@testable import HangulString

final class CharacterTests: XCTestCase {

    // MARK: - isHangulSyllable
    func testIsHangulSyllable() {
        // 아 in Hangul Syllable
        XCTAssertTrue(Character("\u{C544}").isHangulSyllable)

        // 아 in Hangul Jamo
        XCTAssertFalse(Character("\u{110B}\u{1161}").isHangulSyllable)

        // Others
        XCTAssertFalse(Character("1").isHangulSyllable)
        XCTAssertFalse(Character("a").isHangulSyllable)
        XCTAssertFalse(Character(".").isHangulSyllable)
        XCTAssertFalse(Character("あ").isHangulSyllable)
    }

    func testIsHangulSyllable_true() {
        // minimum
        XCTAssertTrue(Character("\u{AC00}").isHangulSyllable)
        XCTAssertFalse(Character("\u{1100}\u{1161}").isHangulSyllable)

        // maximum
        XCTAssertTrue(Character("\u{D7A3}").isHangulSyllable)
        XCTAssertFalse(Character("\u{1112}\u{1175}\u{11C2}").isHangulSyllable)
    }

    func testIsHangulSyllable_false() {
        // minimum - 1
        XCTAssertFalse(Character("\u{ABFF}").isHangulSyllable)

        // maximum + 1
        XCTAssertFalse(Character("\u{D7B0}").isHangulSyllable)
    }

    // MARK: - jamos
    func testJamos() {
        // 가
        XCTAssertEqual(
            Character("\u{AC00}").toHangulJamos()!.unicodeScalars.map { $0.value },
            Character("\u{1100}\u{1161}").unicodeScalars.map { $0.value })
        XCTAssertEqual(
            Character("\u{1100}\u{1161}").toHangulJamos()!.unicodeScalars.map { $0.value },
            Character("\u{1100}\u{1161}").unicodeScalars.map { $0.value })

        // 힣
        XCTAssertEqual(
            Character("\u{D7A3}").toHangulJamos()!.unicodeScalars.map { $0.value },
            Character("\u{1112}\u{1175}\u{11C2}").unicodeScalars.map { $0.value })
        XCTAssertEqual(
            Character("\u{1112}\u{1175}\u{11C2}").toHangulJamos()!.unicodeScalars.map { $0.value },
            Character("\u{1112}\u{1175}\u{11C2}").unicodeScalars.map { $0.value })

        // 젊
        XCTAssertEqual(
            Character("\u{C80A}").toHangulJamos()!.unicodeScalars.map { $0.value },
            Character("\u{110C}\u{1165}\u{11B1}").unicodeScalars.map { $0.value })
        XCTAssertEqual(
            Character("\u{110C}\u{1165}\u{11B1}").toHangulJamos()!.unicodeScalars.map { $0.value },
            Character("\u{110C}\u{1165}\u{11B1}").unicodeScalars.map { $0.value })
    }

    func testJamos_notHangul() {
        XCTAssertNil(Character("1").toHangulJamos())
        XCTAssertNil(Character("a").toHangulJamos())
        XCTAssertNil(Character(".").toHangulJamos())
        XCTAssertNil(Character("あ").toHangulJamos())
    }

    // MARK: - romanized
    func testRomanized() {

        // vowels
        XCTAssertEqual(Character("아").romanized(), "a")
        XCTAssertEqual(Character("야").romanized(), "ya")
        XCTAssertEqual(Character("어").romanized(), "eo")
        XCTAssertEqual(Character("여").romanized(), "yeo")
        XCTAssertEqual(Character("오").romanized(), "o")
        XCTAssertEqual(Character("요").romanized(), "yo")
        XCTAssertEqual(Character("우").romanized(), "u")
        XCTAssertEqual(Character("유").romanized(), "yu")
        XCTAssertEqual(Character("으").romanized(), "eu")
        XCTAssertEqual(Character("이").romanized(), "i")

        // double vowels
        XCTAssertEqual(Character("애").romanized(), "ae")
        XCTAssertEqual(Character("얘").romanized(), "yae")
        XCTAssertEqual(Character("에").romanized(), "e")
        XCTAssertEqual(Character("예").romanized(), "ye")
        XCTAssertEqual(Character("와").romanized(), "wa")
        XCTAssertEqual(Character("왜").romanized(), "wae")
        XCTAssertEqual(Character("외").romanized(), "oe")
        XCTAssertEqual(Character("워").romanized(), "wo")
        XCTAssertEqual(Character("웨").romanized(), "we")
        XCTAssertEqual(Character("위").romanized(), "wi")
        XCTAssertEqual(Character("의").romanized(), "ui")

    }

    func testRomanized_detail() {

        // 가
        XCTAssertEqual(Character("\u{AC00}").romanized(), "ga")
        XCTAssertEqual(Character("\u{1100}\u{1161}").romanized(), "ga")

        // 힣
        XCTAssertEqual(Character("\u{D7A3}").romanized(), "hih")
        XCTAssertEqual(Character("\u{1112}\u{1175}\u{11C2}").romanized(), "hih")

    }

}
