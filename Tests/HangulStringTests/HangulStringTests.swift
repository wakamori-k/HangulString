//
//  HangulStringTests.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/05.
//

import Foundation

import XCTest
import HangulString

final class HangulStringTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        do {
            let hs = try HangulString("아")
            XCTAssertEqual(hs.toString(), "아")
        }
        do {
            let hs = try HangulString("아이")
            XCTAssertEqual(hs.toString(), "아이")
        }
        do {
            let hs = try HangulString("")
            XCTAssertEqual(hs.toString(), "")
        }
    }

    func testInit_error() throws {
        XCTAssertThrowsError(try HangulString("a"))
        XCTAssertThrowsError(try HangulString("あ"))
        XCTAssertThrowsError(try HangulString("a아"))
        XCTAssertThrowsError(try HangulString("ㅇ"))
        XCTAssertThrowsError(try HangulString(" "))
        XCTAssertThrowsError(try HangulString("아 이"))
    }

    func testRomanized() throws {
        XCTAssertEqual(try HangulString("안").romanized(), "an")
        XCTAssertEqual(try HangulString("안녕하세요").romanized(), "an nyeong ha se yo")
        XCTAssertEqual(try HangulString("안녕하세요").romanized(separator: "-"), "an-nyeong-ha-se-yo")
    }

    func testPronounceInKatakana() throws {
        let testCases: [(line: UInt, input: String, expect: String)] = [
            (#line, "안", "アン"),
            (#line, "안녕하세요", "アンニョンハセヨ"),
            (#line, "사랑", "サラン"),
            (#line, "가족", "カジョ(ク)"),
            (#line, "친구", "チング"),
            (#line, "학교", "ハ(ク)ッキョ"),
            (#line, "책", "チェ(ク)"),
            (#line, "영화", "ヨンファ"),
            (#line, "음악", "ウマ(ク)"),
            (#line, "음식", "ウ(ム)シ(ク)"),
            (#line, "물", "ム(ル)"),
            (#line, "커피", "コピ"),
            (#line, "차", "チャ"),
            (#line, "버스", "ポス"),
            (#line, "지하철", "チハチョ(ル)"),
            (#line, "자동차", "チャドンチャ"),
            (#line, "길", "キ(ル)"),
            (#line, "바다", "パダ"),
            (#line, "산", "サン"),
            (#line, "하늘", "ハヌ(ル)"),
            (#line, "날씨", "ナ(ル)ッシ"),
            (#line, "꽃", "ッコッ"),
            (#line, "돈", "トン"),
            (#line, "집", "チ(プ)"),
            (#line, "방", "パン"),
            (#line, "창문", "チャンムン"),
            (#line, "의자", "ウィジャ"),
            (#line, "책상", "チェ(ク)ッサン"),
            (#line, "전화", "チョヌァ"),
            (#line, "컴퓨터", "コ(ム)ピュト"),
            (#line, "인터넷", "イントネッ"),
            (#line, "영어", "ヨンオ"),
            (#line, "결혼", "キョロン"),
            (#line, "사람", "サラ(ム)"),
            (#line, "시간", "シガン"),
            (#line, "사랑해요", "サランヘヨ"),
            (#line, "맛있다", "マシッタ"),
            (#line, "아침", "アチ(ム)"),
            (#line, "저녁", "チョニョ(ク)"),
            (#line, "내일", "ネイ(ル)"),
            (#line, "어제", "オジェ"),
            (#line, "지금", "チグ(ム)"),
            (#line, "빨리", "ッパ(ル)リ"),
            (#line, "천천히", "チョンチョニ"),
            (#line, "고맙습니다", "コマ(プ)ッス(ム)ニダ"),
            (#line, "죄송합니다", "チェソンハ(ム)ニダ"),
            (#line, "괜찮아요", "クェンチャナヨ"),
            (#line, "부탁합니다", "プタカ(ム)ニダ"),
            (#line, "문", "ムン"),
            (#line, "자동차", "チャドンチャ"),
            (#line, "공항", "コンハン"),
            (#line, "역", "ヨ(ク)"),
            (#line, "편지", "ピョンジ"),
            (#line, "질문", "チ(ル)ムン"),
            (#line, "대답", "テダ(プ)"),
            (#line, "병원", "ピョンウォン"),
            (#line, "약", "ヤ(ク)"),
            (#line, "기차", "キチャ"),
            (#line, "비행기", "ピヘンギ"),
            (#line, "경찰", "キョンチャ(ル)"),
            (#line, "불", "プ(ル)"),
            (#line, "돼지", "トェジ"),
            (#line, "소", "ソ"),
            (#line, "고양이", "コヤンイ"),
            (#line, "개", "ケ"),
            (#line, "사과", "サグァ"),
            (#line, "바나나", "パナナ"),
            (#line, "오렌지", "オレンジ"),
            (#line, "딸기", "ッタ(ル)ギ"),
            (#line, "포도", "ポド"),
            (#line, "수박", "スバ(ク)"),
            (#line, "김치", "キ(ム)チ"),
            (#line, "된장찌개", "トェンジャンッチゲ"),
            (#line, "비빔밥", "ピビ(ム)バ(プ)"),
            (#line, "불고기", "プ(ル)ゴギ"),
            (#line, "삼겹살", "サ(ム)ギョ(プ)ッサ(ル)"),
            (#line, "잡채", "チャ(プ)チェ"),
            (#line, "순두부찌개", "スンドゥブッチゲ"),
            (#line, "갈비", "カ(ル)ビ"),
            (#line, "떡볶이", "ット(ク)ッポッキ"),
            (#line, "핸드폰", "ヘンドゥポン"),
            (#line, "컴퓨터", "コ(ム)ピュト"),
            (#line, "책방", "チェ(ク)ッパン"),
            (#line, "옷", "オッ"),
            (#line, "신발", "シンバ(ル)"),
            (#line, "모자", "モジャ"),
            (#line, "우산", "ウサン"),
            (#line, "창문", "チャンムン"),
            (#line, "신문", "シンムン"),
            (#line, "잡지", "チャ(プ)ッチ"),
            (#line, "공원", "コンウォン"),
            (#line, "시장", "シジャン"),
            (#line, "백화점", "ペクァジョ(ム)")
        ]
        for testCase in testCases {
            XCTAssertEqual(try HangulString(testCase.input).pronounceInKatakana(), testCase.expect, line: testCase.line)
        }
    }

    func testMakeIterator() throws {
        do {
            let hangulString = try HangulString("안녕하세요")
            var characters: [HangulCharacter] = []

            for character in hangulString {
                characters.append(character)
            }

            let resultString = String(characters.map { $0.toSyllableCharacter() })
            XCTAssertEqual(resultString, "안녕하세요")
        }
        do {
            let hangulString = try HangulString("")
            var characters: [HangulCharacter] = []

            for character in hangulString {
                characters.append(character)
            }

            XCTAssertEqual(characters.count, 0)
        }
    }

    func testSubscript() throws {
        var hangulString = try HangulString("안녕하세요")
        XCTAssertEqual(hangulString[0], try HangulCharacter("안"))
        XCTAssertEqual(hangulString[1], try HangulCharacter("녕"))
        XCTAssertEqual(hangulString[2], try HangulCharacter("하"))
        XCTAssertEqual(hangulString[3], try HangulCharacter("세"))
        XCTAssertEqual(hangulString[4], try HangulCharacter("요"))

        hangulString[2] = try HangulCharacter("마")
        XCTAssertEqual(hangulString[0], try HangulCharacter("안"))
        XCTAssertEqual(hangulString[1], try HangulCharacter("녕"))
        XCTAssertEqual(hangulString[2], try HangulCharacter("마"))
        XCTAssertEqual(hangulString[3], try HangulCharacter("세"))
        XCTAssertEqual(hangulString[4], try HangulCharacter("요"))
    }

    func testEquatable() throws {
        XCTAssertEqual(try HangulString(""), try HangulString(""))
        XCTAssertEqual(try HangulString("안"), try HangulString("안"))
        XCTAssertEqual(try HangulString("안녕하세요"), try HangulString("안녕하세요"))
        // compare jamos and syllable
        XCTAssertEqual(try HangulString("\u{1100}\u{1161}\u{11A8}"), try HangulString("\u{AC01}")) // 각
        XCTAssertEqual(try HangulString("\u{AC01}"), try HangulString("\u{1100}\u{1161}\u{11A8}")) // 각
        XCTAssertEqual(try HangulString("\u{1112}\u{1175}\u{11C2}"), try HangulString("\u{D7A3}")) // 힣
        XCTAssertEqual(try HangulString("\u{D7A3}"), try HangulString("\u{1112}\u{1175}\u{11C2}")) // 힣
    }

    func testEquatable_negative() throws {
        XCTAssertNotEqual(try HangulString("안"), try HangulString(""))
        XCTAssertNotEqual(try HangulString(""), try HangulString("안"))
        XCTAssertNotEqual(try HangulString("안녕하세"), try HangulString("안녕하세요"))
        XCTAssertNotEqual(try HangulString("안녕하세요"), try HangulString("안녕하세"))
        // compare jamos and syllable
        XCTAssertNotEqual(try HangulString("\u{1100}\u{1161}"), try HangulString("\u{AC01}"))
        XCTAssertNotEqual(try HangulString("\u{1100}\u{1161}\u{11A8}"), try HangulString("\u{AC02}"))
    }

    func testCompare() throws {
        XCTAssertLessThan(try HangulString(""), try HangulString("안"))
        XCTAssertGreaterThan(try HangulString("안"), try HangulString(""))
        XCTAssertLessThan(try HangulString("안"), try HangulString("았"))
        XCTAssertGreaterThan(try HangulString("았"), try HangulString("안"))
        XCTAssertLessThan(try HangulString("안녕하세"), try HangulString("안녕하세요"))
        XCTAssertGreaterThan(try HangulString("안녕하세요"), try HangulString("안녕하세"))
        XCTAssertLessThan(try HangulString("안녕하세요"), try HangulString("안녕하세욤"))
        XCTAssertGreaterThan(try HangulString("안녕하세욤"), try HangulString("안녕하세요"))
        // compare jamos and syllable
        XCTAssertLessThan(try HangulString("\u{1100}\u{1161}\u{11A8}"), try HangulString("\u{AC11}")) // 각, 갑
        XCTAssertGreaterThan(try HangulString("\u{1100}\u{1161}\u{11B8}"), try HangulString("\u{AC01}")) // 갑, 각
        XCTAssertGreaterThan(try HangulString("\u{AC11}"), try HangulString("\u{1100}\u{1161}\u{11A8}")) // 갑, 각
        XCTAssertLessThan(try HangulString("\u{AC01}"), try HangulString("\u{1100}\u{1161}\u{11B8}")) // 각, 갑
    }
}
