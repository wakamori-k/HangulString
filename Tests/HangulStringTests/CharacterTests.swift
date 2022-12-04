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
        XCTAssertTrue(Character("\u{D7AF}").isHangulSyllable)
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
        XCTAssertEqual(Character("\u{AC00}").hangulJamos, ["\u{1100}", "\u{1161}"])
        XCTAssertEqual(Character("\u{1100}\u{1161}").hangulJamos, ["\u{1100}", "\u{1161}"])
        
        // 힣
        XCTAssertEqual(Character("\u{D7A3}").hangulJamos, ["\u{1112}", "\u{1175}", "\u{11C2}"])
        XCTAssertEqual(Character("\u{1112}\u{1175}\u{11C2}").hangulJamos, ["\u{1112}", "\u{1175}", "\u{11C2}"])
    }
    
    func testJamos_notHangul() {
        XCTAssertNil(Character("1").hangulJamos)
        XCTAssertNil(Character("a").hangulJamos)
        XCTAssertNil(Character(".").hangulJamos)
        XCTAssertNil(Character("あ").hangulJamos)
    }
    
    // MARK: - romanized
    func testRomanized() {
        
        // 가
        XCTAssertEqual(Character("\u{AC00}").romanized(), "ga")
        XCTAssertEqual(Character("\u{1100}\u{1161}").romanized(), "ga")
        
        // 힣
        XCTAssertEqual(Character("\u{D7A3}").romanized(), "hih")
        XCTAssertEqual(Character("\u{1112}\u{1175}\u{11C2}").romanized(), "hih")

    }

}
