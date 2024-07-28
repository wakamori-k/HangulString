//
//  PhonologicalConverterTests.swift
//
//
//  Created by Kazumasa Wakamori on 2024/06/02.
//

import XCTest
@testable import HangulString
final class PhonologicalConverterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResyllabificationConverter() throws {
        let testCases: [(String, String)] = [
            // single consonant
            ("옷을", "오슬"),
            ("입어요", "이버요"),
            ("책이", "채기"),
            ("질문이", "질무니"),
            ("신용", "시뇽"),
            // double single consonant
            ("앉아", "안자"),
            ("젊어요", "절머요"),
            ("맑음", "말금"),
            // geminate consonant
            ("있어요", "이써요"),
            ("재밌어요", "재미써요"),
            ("깎아", "까까"),
            // Mixed
            ("알았어요", "아라써요"),
            // consonant ends with ㅎ
            ("좋아", "조아"),
            ("싫어", "시러")
        ]
        for testCase in testCases {
            let converted = try ResyllabificationConverter.convert(hangulString: try HangulString(testCase.0))
            XCTAssertEqual(converted.toString(), testCase.1)
        }
    }

    func testResyllabificationConverter_noConversion() throws {
        let testCases = [
            // empty
            "",
            // single letter
            "아",
            // single letter having a final consonant
            "안",
            // following character does not start with vowel
            "안사",
            // character does not have a final consonant
            "바아",
            // character does ends with the consonant ieung (`ㅇ`)
            "생일",
            "중요",
            "종이",
            // Others
            "반하"
        ]
        for testCase in testCases {
            let converted = try ResyllabificationConverter.convert(hangulString: try HangulString(testCase))
            XCTAssertEqual(converted.toString(), testCase)
        }
    }

    func testReinforcementConverter() throws {
        let testCases: [(String, String)] = [
            // ㄱ
            ("책상", "책쌍"),
            ("낚시", "낚씨"),

            // ㄷ
            ("싣다", "싣따"),
            // ㅌ
            ("샅바", "샅빠"),
            // ㅅ
            ("없고", "없꼬"),
            // ㅆ
            ("있다", "있따"),
            // ㅈ
            ("잊다", "잊따"),
            // ㅊ
            ("꽃집", "꽃찝"),
            ("꽃밭", "꽃빹"),
            // ㅎ
            ("낳습니다", "낳씁니다"),

            // ㅂ
            ("덥다", "덥따"),
            // ㅍ
            ("덮다", "덮따")

        ]
        for testCase in testCases {
            let converted = try ReinforcementConverter.convert(hangulString: try HangulString(testCase.0))
            XCTAssertEqual(converted.toString(), testCase.1)
        }
    }

    func testReinforcementConverter_noConversion() throws {
        let testCases = [
            // empty
            "",
            // single letter
            "아",
            // single letter having a final consonant
            "안",
            // ending with ㅎ, and the following initial consonant is not ㅅ.
            "낳다"
        ]
        for testCase in testCases {
            let converted = try ReinforcementConverter.convert(hangulString: try HangulString(testCase))
            XCTAssertEqual(converted.toString(), testCase)
        }
    }

    func testEndingConsonantSimplificationConverter() throws {
        let testCases: [(String, String)] = [
            // [.kieuk] -> [.giyeok],
            ("녘", "녁"),
            // [.tieut] -> [.digeut],
            ("밑", "믿"),
            ("샅빠", "삳빠"),
            // [.pieup] -> [.bieup],
            ("덮치다", "덥치다"),
            // [.siot] -> [.digeut],
            ("못", "몯"),
            ("맛깔", "맏깔"),
            // [.siot, .siot] -> [.digeut],
            ("있다", "읻다"),
            // [.chieut] -> [.digeut],
            ("꽃씨", "꼳씨"),
            ("꽃빹", "꼳빧"),
            // [.jieut] -> [.digeut],
            ("곶", "곧"),
            ("젖꼭", "젇꼭"),
            // [.giyeok, .giyeok] -> [.giyeok],
            ("낚씨", "낙씨"),
            ("꺾쇠", "꺽쇠"),
            ("밖", "박")
        ]
        for testCase in testCases {
            let converted = try EndingConsonantSimplificationConverter.convert(
                hangulString: try HangulString(testCase.0))
            XCTAssertEqual(converted.toString(), testCase.1)
        }
    }
    func testEndingConsonantSimplificationConverter_noConversion() throws {
        let testCases = [
            // empty
            "",
            // no final consonant
            "아",
            // next character starts with vowel
            "덮이다"
        ]
        for testCase in testCases {
            let converted = try EndingConsonantSimplificationConverter.convert(hangulString: try HangulString(testCase))
            XCTAssertEqual(converted.toString(), testCase)
        }
    }

    func testNasalisationConverter() throws {
        let testCases: [(String, String)] = [
            // `ㄱ` -> `ㅇ`
            ("박물관", "방물관"),
            ("한국말", "한궁말"),
            // `ㄷ` -> `ㄴ`
            ("믿는", "민는"),
            // `ㅅ` -> `ㄴ`
            ("옷맵시", "온맵시"),
            // `ㅈ` -> `ㄴ`
            ("앚는", "안는"),
            // `ㅊ` -> `ㄴ`
            ("꽃말", "꼰말"),
            // `ㅂ` -> `ㅁ`
            ("감사합니다", "감사함니다"),
            // `ㄱ` ->  `ㅇ` and `ㄹ` -> `ㄴ`.
            ("독립", "동닙")
        ]
        for testCase in testCases {
            let converted = try NasalisationConverter.convert(
                hangulString: try HangulString(testCase.0))
            XCTAssertEqual(converted.toString(), testCase.1)
        }
    }
    func testNasalisationConverter_noConversion() throws {
        let testCases = [
            // empty
            "",
            // single character
            "박",
            "믿",
            "옷",
            "앚",
            "합",
            "독",
            // next character does not start with target consonants
            "박아",
            "한국아",
            "믿아",
            "옷아",
            "앚아",
            "감사합아"
        ]
        for testCase in testCases {
            let converted = try NasalisationConverter.convert(hangulString: try HangulString(testCase))
            XCTAssertEqual(converted.toString(), testCase)
        }
    }

    func testAssimilationConverter() throws {
        let testCases: [(String, String)] = [
            ("실내", "실래"),
            ("신라", "실라")
        ]
        for testCase in testCases {
            let converted = try AssimilationConverter.convert(
                hangulString: try HangulString(testCase.0))
            XCTAssertEqual(converted.toString(), testCase.1)
        }
    }
    func testAssimilationConverter_noConversion() throws {
        let testCases = [
            // empty
            "",
            // single character
            "실",
            "내",
            // next character does not start with target consonants
            "실아",
            "신아"
        ]
        for testCase in testCases {
            let converted = try AssimilationConverter.convert(hangulString: try HangulString(testCase))
            XCTAssertEqual(converted.toString(), testCase)
        }
    }

    func testAspirationConverter() throws {
        let testCases: [(String, String)] = [
            // starts with ㅎ
            ("북한", "부칸"),
            ("맞히다", "마치다"),
            ("축하해", "추카해"),
            ("입학", "이팍"),
            ("맞히다", "마치다"),
            // ends with ㅎ
            ("좋다", "조타"),
            ("많다", "만타"),
            ("잃지", "일치"),
            ("않다", "안타")
        ]
        for testCase in testCases {
            let converted = try AspirationConverter.convert(
                hangulString: try HangulString(testCase.0))
            XCTAssertEqual(converted.toString(), testCase.1)
        }
    }
    func testAspirationConverter_noConversion() throws {
        let testCases = [
            // empty
            "",
            // single character
            "북",
            "북",
            "않",
            // next character does not start with target consonants
            "북아",
            "좋아"
        ]
        for testCase in testCases {
            let converted = try AspirationConverter.convert(hangulString: try HangulString(testCase))
            XCTAssertEqual(converted.toString(), testCase)
        }
    }

    func testPalatalisationConverter() throws {
        let testCases: [(String, String)] = [
            ("굳이", "구지"),
            ("같이", "가치"),
            ("핥이다", "할치다"),
            ("묻히다", "무치다"),
            ("닫히다", "다치다")
        ]
        for testCase in testCases {
            let converted = try PalatalisationConverter.convert(
                hangulString: try HangulString(testCase.0))
            XCTAssertEqual(converted.toString(), testCase.1)
        }
    }
    func testPalatalisationConverter_noConversion() throws {
        let testCases = [
            // empty
            "",
            // single character
            "굳",
            "같",
            "핥",
            "닫",
            // next character does not start with target consonants
            "굳아",
            "같아",
            "핥아",
            "닫아"
        ]
        for testCase in testCases {
            let converted = try PalatalisationConverter.convert(hangulString: try HangulString(testCase))
            XCTAssertEqual(converted.toString(), testCase)
        }
    }

    func testSilenationHieutConverter() throws {
        let testCases: [(String, String)] = [
            ("결혼", "겨론"),
            ("전화", "저놔"),
            ("엄하다", "어마다")
        ]
        for testCase in testCases {
            let converted = try SilenationHieutConverter.convert(
                hangulString: try HangulString(testCase.0))
            XCTAssertEqual(converted.toString(), testCase.1)
        }
    }
    func testSilenationHieutConverter_noConversion() throws {
        let testCases = [
            // empty
            "",
            // single character
            "결",
            "혼",
            // next character does not start with target consonant
            "굳아",
            "같아",
            "핥아",
            "닫아",
            "방학"
        ]
        for testCase in testCases {
            let converted = try PalatalisationConverter.convert(hangulString: try HangulString(testCase))
            XCTAssertEqual(converted.toString(), testCase)
        }
    }

}
