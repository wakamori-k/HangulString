//
//  HangulCharacterTests.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/05.
//

import XCTest
@testable import HangulString
// swiftlint:disable file_length
final class HangulCharacterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        do {
            let hc = try HangulCharacter("아")
            XCTAssertEqual(hc.toSyllableCharacter(), "아")
            XCTAssertEqual(hc.toJamoCharacter(), "아")
        }

        // Instantinate with syllables
        do {
            let hc = try HangulCharacter("\u{AC00}") // 가
            XCTAssertEqual(hc.toSyllableCharacter().unicodeScalars.map { $0.value }, [0xAC00])
            XCTAssertEqual(hc.toJamoCharacter().unicodeScalars.map { $0.value }, [0x1100, 0x1161])
        }
        do {
            let hc = try HangulCharacter("\u{D7A3}") // 힣
            XCTAssertEqual(hc.toSyllableCharacter().unicodeScalars.map { $0.value }, [0xD7A3])
            XCTAssertEqual(hc.toJamoCharacter().unicodeScalars.map { $0.value }, [0x1112, 0x1175, 0x11C2])
        }

        // Instantinate with jamos
        do {
            let hc = try HangulCharacter("\u{1100}\u{1161}") // 가
            XCTAssertEqual(hc.toSyllableCharacter().unicodeScalars.map { $0.value }, [0xAC00])
            XCTAssertEqual(hc.toJamoCharacter().unicodeScalars.map { $0.value }, [0x1100, 0x1161])
        }
        do {
            let hc = try HangulCharacter("\u{1112}\u{1175}\u{11C2}") // 힣
            XCTAssertEqual(hc.toSyllableCharacter().unicodeScalars.map { $0.value }, [0xD7A3])
            XCTAssertEqual(hc.toJamoCharacter().unicodeScalars.map { $0.value }, [0x1112, 0x1175, 0x11C2])
        }
    }

    func testInit_error() throws {
        XCTAssertThrowsError(try HangulCharacter("\u{1100}")) { error in // “ᄀ”
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidCharacter)
        }
        XCTAssertThrowsError(try HangulCharacter("ㅇ")) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidCharacter)
        }
        XCTAssertThrowsError(try HangulCharacter("a")) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidCharacter)
        }
        XCTAssertThrowsError(try HangulCharacter("あ")) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidCharacter)
        }
        XCTAssertThrowsError(try HangulCharacter(" ")) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidCharacter)
        }
        XCTAssertThrowsError(try HangulCharacter(".")) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidCharacter)
        }
        XCTAssertThrowsError(try HangulCharacter(",")) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidCharacter)
        }
        XCTAssertThrowsError(try HangulCharacter("!")) { error in
            XCTAssertEqual(error as! HangulStringError, HangulStringError.invalidCharacter)
        }
    }

    func testInit_fromHangulCharacterInJamos() throws {
        do {
            let c = HangulCharacterInJamos(initialConsonant: [.ieung], vowel: .a)
            let hc = try HangulCharacter(c)
            XCTAssertEqual(hc.toSyllableCharacter(), "아")
            XCTAssertEqual(hc.toJamoCharacter(), "아")
        }
        do {
            // 가
            let c = HangulCharacterInJamos(initialConsonant: [.giyeok], vowel: .a)
            let hc = try HangulCharacter(c)
            XCTAssertEqual(hc.toSyllableCharacter().unicodeScalars.map { $0.value }, [0xAC00])
            XCTAssertEqual(hc.toJamoCharacter().unicodeScalars.map { $0.value }, [0x1100, 0x1161])
        }
        do {
            // 힣
            let c = HangulCharacterInJamos(initialConsonant: [.hieut], vowel: .i, finalConsonant: [.hieut])
            let hc = try HangulCharacter(c)
            XCTAssertEqual(hc.toSyllableCharacter().unicodeScalars.map { $0.value }, [0xD7A3])
            XCTAssertEqual(hc.toJamoCharacter().unicodeScalars.map { $0.value }, [0x1112, 0x1175, 0x11C2])
        }
    }

    func testRomanized_InitialConsonants() {
        XCTAssertEqual(try HangulCharacter(Character("가")).romanized(), "ga")
        XCTAssertEqual(try HangulCharacter(Character("까")).romanized(), "kka")
        XCTAssertEqual(try HangulCharacter(Character("나")).romanized(), "na")
        XCTAssertEqual(try HangulCharacter(Character("다")).romanized(), "da")
        XCTAssertEqual(try HangulCharacter(Character("따")).romanized(), "tta")
        XCTAssertEqual(try HangulCharacter(Character("라")).romanized(), "ra")
        XCTAssertEqual(try HangulCharacter(Character("마")).romanized(), "ma")
        XCTAssertEqual(try HangulCharacter(Character("바")).romanized(), "ba")
        XCTAssertEqual(try HangulCharacter(Character("빠")).romanized(), "ppa")
        XCTAssertEqual(try HangulCharacter(Character("사")).romanized(), "sa")
        XCTAssertEqual(try HangulCharacter(Character("싸")).romanized(), "ssa")
        XCTAssertEqual(try HangulCharacter(Character("아")).romanized(), "a")
        XCTAssertEqual(try HangulCharacter(Character("자")).romanized(), "ja")
        XCTAssertEqual(try HangulCharacter(Character("짜")).romanized(), "jja")
        XCTAssertEqual(try HangulCharacter(Character("차")).romanized(), "cha")
        XCTAssertEqual(try HangulCharacter(Character("카")).romanized(), "ka")
        XCTAssertEqual(try HangulCharacter(Character("타")).romanized(), "ta")
        XCTAssertEqual(try HangulCharacter(Character("파")).romanized(), "pa")
        XCTAssertEqual(try HangulCharacter(Character("하")).romanized(), "ha")
    }

    func testRomanized_Vowels() {
        XCTAssertEqual(try HangulCharacter(Character("아")).romanized(), "a")
        XCTAssertEqual(try HangulCharacter(Character("야")).romanized(), "ya")
        XCTAssertEqual(try HangulCharacter(Character("어")).romanized(), "eo")
        XCTAssertEqual(try HangulCharacter(Character("여")).romanized(), "yeo")
        XCTAssertEqual(try HangulCharacter(Character("오")).romanized(), "o")
        XCTAssertEqual(try HangulCharacter(Character("요")).romanized(), "yo")
        XCTAssertEqual(try HangulCharacter(Character("우")).romanized(), "u")
        XCTAssertEqual(try HangulCharacter(Character("유")).romanized(), "yu")
        XCTAssertEqual(try HangulCharacter(Character("으")).romanized(), "eu")
        XCTAssertEqual(try HangulCharacter(Character("이")).romanized(), "i")

        XCTAssertEqual(try HangulCharacter(Character("애")).romanized(), "ae")
        XCTAssertEqual(try HangulCharacter(Character("얘")).romanized(), "yae")
        XCTAssertEqual(try HangulCharacter(Character("에")).romanized(), "e")
        XCTAssertEqual(try HangulCharacter(Character("예")).romanized(), "ye")
        XCTAssertEqual(try HangulCharacter(Character("와")).romanized(), "wa")
        XCTAssertEqual(try HangulCharacter(Character("왜")).romanized(), "wae")
        XCTAssertEqual(try HangulCharacter(Character("외")).romanized(), "oe")
        XCTAssertEqual(try HangulCharacter(Character("워")).romanized(), "wo")
        XCTAssertEqual(try HangulCharacter(Character("웨")).romanized(), "we")
        XCTAssertEqual(try HangulCharacter(Character("위")).romanized(), "wi")
        XCTAssertEqual(try HangulCharacter(Character("의")).romanized(), "ui")
    }

    func testRomanized_FinalConsonants() {
        XCTAssertEqual(try HangulCharacter(Character("악")).romanized(), "ak")
        XCTAssertEqual(try HangulCharacter(Character("앆")).romanized(), "akk")
        XCTAssertEqual(try HangulCharacter(Character("앇")).romanized(), "aks")
        XCTAssertEqual(try HangulCharacter(Character("안")).romanized(), "an")
        XCTAssertEqual(try HangulCharacter(Character("앉")).romanized(), "anj")
        XCTAssertEqual(try HangulCharacter(Character("않")).romanized(), "anh")
        XCTAssertEqual(try HangulCharacter(Character("앋")).romanized(), "at")
        XCTAssertEqual(try HangulCharacter(Character("알")).romanized(), "al")
        XCTAssertEqual(try HangulCharacter(Character("앍")).romanized(), "alk")
        XCTAssertEqual(try HangulCharacter(Character("앎")).romanized(), "alm")
        XCTAssertEqual(try HangulCharacter(Character("앏")).romanized(), "alp")
        XCTAssertEqual(try HangulCharacter(Character("앑")).romanized(), "alt")
        XCTAssertEqual(try HangulCharacter(Character("앒")).romanized(), "alp")
        XCTAssertEqual(try HangulCharacter(Character("앓")).romanized(), "alh")
        XCTAssertEqual(try HangulCharacter(Character("암")).romanized(), "am")
        XCTAssertEqual(try HangulCharacter(Character("압")).romanized(), "ap")
        XCTAssertEqual(try HangulCharacter(Character("앖")).romanized(), "aps")
        XCTAssertEqual(try HangulCharacter(Character("앗")).romanized(), "as")
        XCTAssertEqual(try HangulCharacter(Character("았")).romanized(), "ass")
        XCTAssertEqual(try HangulCharacter(Character("앙")).romanized(), "ang")
        XCTAssertEqual(try HangulCharacter(Character("앚")).romanized(), "aj")
        XCTAssertEqual(try HangulCharacter(Character("앛")).romanized(), "ach")
        XCTAssertEqual(try HangulCharacter(Character("앜")).romanized(), "ak")
        XCTAssertEqual(try HangulCharacter(Character("앝")).romanized(), "at")
        XCTAssertEqual(try HangulCharacter(Character("앞")).romanized(), "ap")
        XCTAssertEqual(try HangulCharacter(Character("앟")).romanized(), "ah")
    }

    func testRomanized_detail() {

        // 가
        XCTAssertEqual(try HangulCharacter(Character("\u{AC00}")).romanized(), "ga")
        XCTAssertEqual(try HangulCharacter(Character("\u{1100}\u{1161}")).romanized(), "ga")

        // 힣
        XCTAssertEqual(try HangulCharacter(Character("\u{D7A3}")).romanized(), "hih")
        XCTAssertEqual(try HangulCharacter(Character("\u{1112}\u{1175}\u{11C2}")).romanized(), "hih")
    }

    func testToJamos() {
        XCTAssertEqual(try HangulCharacter("아").toJamos(),
                       HangulCharacterInJamos(initialConsonant: [.ieung],
                                              vowel: .a))
        XCTAssertEqual(try HangulCharacter("건").toJamos(),
                       HangulCharacterInJamos(initialConsonant: [.giyeok],
                                              vowel: .eo,
                                              finalConsonant: [.nieun]))
        XCTAssertEqual(try HangulCharacter("짃").toJamos(),
                       HangulCharacterInJamos(initialConsonant: [.jieut],
                                              vowel: .i,
                                              finalConsonant: [.giyeok, .siot]))
        XCTAssertEqual(try HangulCharacter("쓺").toJamos(),
                       HangulCharacterInJamos(initialConsonant: [.siot, .siot],
                                              vowel: .eu,
                                              finalConsonant: [.rieul, .mieum]))
    }

    func testKatakanize() {
        let testCases: [(UInt, Character, String)] = [
            (#line, "가", "カ"),
            (#line, "갸", "キャ"),
            (#line, "거", "コ"),
            (#line, "겨", "キョ"),
            (#line, "고", "コ"),
            (#line, "교", "キョ"),
            (#line, "구", "ク"),
            (#line, "규", "キュ"),
            (#line, "그", "ク"),
            (#line, "기", "キ"),
            (#line, "개", "ケ"),
            (#line, "걔", "ケ"),
            (#line, "게", "ケ"),
            (#line, "계", "ケ"),
            (#line, "과", "クァ"),
            (#line, "괘", "クェ"),
            (#line, "괴", "クェ"),
            (#line, "궈", "クォ"),
            (#line, "궤", "クェ"),
            (#line, "귀", "クィ"),
            (#line, "긔", "キ"),
            (#line, "나", "ナ"),
            (#line, "냐", "ニャ"),
            (#line, "너", "ノ"),
            (#line, "녀", "ニョ"),
            (#line, "노", "ノ"),
            (#line, "뇨", "ニョ"),
            (#line, "누", "ヌ"),
            (#line, "뉴", "ニュ"),
            (#line, "느", "ヌ"),
            (#line, "니", "ニ"),
            (#line, "내", "ネ"),
            (#line, "냬", "ネ"),
            (#line, "네", "ネ"),
            (#line, "녜", "ネ"),
            (#line, "놔", "ヌァ"),
            (#line, "놰", "ヌェ"),
            (#line, "뇌", "ヌェ"),
            (#line, "눠", "ヌォ"),
            (#line, "눼", "ヌェ"),
            (#line, "뉘", "ヌィ"),
            (#line, "늬", "ニ"),
            (#line, "다", "タ"),
            (#line, "댜", "ティャ"),
            (#line, "더", "ト"),
            (#line, "뎌", "テョ"),
            (#line, "도", "ト"),
            (#line, "됴", "テョ"),
            (#line, "두", "トゥ"),
            (#line, "듀", "テュ"),
            (#line, "드", "トゥ"),
            (#line, "디", "ティ"),
            (#line, "대", "テ"),
            (#line, "댸", "テ"),
            (#line, "데", "テ"),
            (#line, "뎨", "テ"),
            (#line, "돠", "トァ"),
            (#line, "돼", "トェ"),
            (#line, "되", "トェ"),
            (#line, "둬", "トォ"),
            (#line, "뒈", "トェ"),
            (#line, "뒤", "トィ"),
            (#line, "듸", "ティ"),
            (#line, "라", "ラ"),
            (#line, "랴", "リャ"),
            (#line, "러", "ロ"),
            (#line, "려", "リョ"),
            (#line, "로", "ロ"),
            (#line, "료", "リョ"),
            (#line, "루", "ル"),
            (#line, "류", "リュ"),
            (#line, "르", "ル"),
            (#line, "리", "リ"),
            (#line, "래", "レ"),
            (#line, "럐", "レ"),
            (#line, "레", "レ"),
            (#line, "례", "レ"),
            (#line, "롸", "ルァ"),
            (#line, "뢔", "ルェ"),
            (#line, "뢰", "ルェ"),
            (#line, "뤄", "ルォ"),
            (#line, "뤠", "ルェ"),
            (#line, "뤼", "ルィ"),
            (#line, "릐", "リ"),
            (#line, "마", "マ"),
            (#line, "먀", "ミャ"),
            (#line, "머", "モ"),
            (#line, "며", "ミョ"),
            (#line, "모", "モ"),
            (#line, "묘", "ミョ"),
            (#line, "무", "ム"),
            (#line, "뮤", "ミュ"),
            (#line, "므", "ム"),
            (#line, "미", "ミ"),
            (#line, "매", "メ"),
            (#line, "먜", "メ"),
            (#line, "메", "メ"),
            (#line, "몌", "メ"),
            (#line, "뫄", "ムァ"),
            (#line, "뫠", "ムェ"),
            (#line, "뫼", "ムェ"),
            (#line, "뭐", "ムォ"),
            (#line, "뭬", "ムェ"),
            (#line, "뮈", "ムィ"),
            (#line, "믜", "ミ"),
            (#line, "바", "パ"),
            (#line, "뱌", "ピャ"),
            (#line, "버", "ポ"),
            (#line, "벼", "ピョ"),
            (#line, "보", "ポ"),
            (#line, "뵤", "ピョ"),
            (#line, "부", "プ"),
            (#line, "뷰", "ピュ"),
            (#line, "브", "プ"),
            (#line, "비", "ピ"),
            (#line, "배", "ペ"),
            (#line, "뱨", "ペ"),
            (#line, "베", "ペ"),
            (#line, "볘", "ペ"),
            (#line, "봐", "プァ"),
            (#line, "봬", "プェ"),
            (#line, "뵈", "プェ"),
            (#line, "붜", "ポォ"),
            (#line, "붸", "プェ"),
            (#line, "뷔", "プィ"),
            (#line, "븨", "ピ"),
            (#line, "사", "サ"),
            (#line, "샤", "シャ"),
            (#line, "서", "ソ"),
            (#line, "셔", "ショ"),
            (#line, "소", "ソ"),
            (#line, "쇼", "ショ"),
            (#line, "수", "ス"),
            (#line, "슈", "シュ"),
            (#line, "스", "ス"),
            (#line, "시", "シ"),
            (#line, "새", "セ"),
            (#line, "섀", "セ"),
            (#line, "세", "セ"),
            (#line, "셰", "セ"),
            (#line, "솨", "スァ"),
            (#line, "쇄", "スェ"),
            (#line, "쇠", "スェ"),
            (#line, "숴", "スォ"),
            (#line, "쉐", "スェ"),
            (#line, "쉬", "スィ"),
            (#line, "싀", "シ"),
            (#line, "아", "ア"),
            (#line, "야", "ヤ"),
            (#line, "어", "オ"),
            (#line, "여", "ヨ"),
            (#line, "오", "オ"),
            (#line, "요", "ヨ"),
            (#line, "우", "ウ"),
            (#line, "유", "ユ"),
            (#line, "으", "ウ"),
            (#line, "이", "イ"),
            (#line, "애", "エ"),
            (#line, "얘", "イェ"),
            (#line, "에", "エ"),
            (#line, "예", "イェ"),
            (#line, "와", "ワ"),
            (#line, "왜", "ウェ"),
            (#line, "외", "ウェ"),
            (#line, "워", "ウォ"),
            (#line, "웨", "ウェ"),
            (#line, "위", "ウィ"),
            (#line, "의", "ウィ"),
            (#line, "자", "チャ"),
            (#line, "쟈", "チャ"),
            (#line, "저", "チョ"),
            (#line, "져", "チョ"),
            (#line, "조", "チョ"),
            (#line, "죠", "チョ"),
            (#line, "주", "チュ"),
            (#line, "쥬", "チュ"),
            (#line, "즈", "チュ"),
            (#line, "지", "チ"),
            (#line, "재", "チェ"),
            (#line, "쟤", "チェ"),
            (#line, "제", "チェ"),
            (#line, "졔", "チェ"),
            (#line, "좌", "チュァ"),
            (#line, "좨", "チュェ"),
            (#line, "죄", "チェ"),
            (#line, "줘", "チョ"),
            (#line, "줴", "チェ"),
            (#line, "쥐", "チュィ"),
            (#line, "즤", "チィ"),
            (#line, "차", "チャ"),
            (#line, "챠", "チャ"),
            (#line, "처", "チョ"),
            (#line, "쳐", "チョ"),
            (#line, "초", "チョ"),
            (#line, "쵸", "チョ"),
            (#line, "추", "チュ"),
            (#line, "츄", "チュ"),
            (#line, "츠", "チュ"),
            (#line, "치", "チ"),
            (#line, "채", "チェ"),
            (#line, "챼", "チェ"),
            (#line, "체", "チェ"),
            (#line, "쳬", "チェ"),
            (#line, "촤", "チュァ"),
            (#line, "쵀", "チュェ"),
            (#line, "최", "チェ"),
            (#line, "춰", "チョ"),
            (#line, "췌", "チェ"),
            (#line, "취", "チュィ"),
            (#line, "츼", "チィ"),
            (#line, "카", "カ"),
            (#line, "캬", "キャ"),
            (#line, "커", "コ"),
            (#line, "켜", "キョ"),
            (#line, "코", "コ"),
            (#line, "쿄", "キョ"),
            (#line, "쿠", "ク"),
            (#line, "큐", "キュ"),
            (#line, "크", "ク"),
            (#line, "키", "キ"),
            (#line, "캐", "ケ"),
            (#line, "컈", "ケ"),
            (#line, "케", "ケ"),
            (#line, "켸", "ケ"),
            (#line, "콰", "クァ"),
            (#line, "쾌", "クェ"),
            (#line, "쾨", "クェ"),
            (#line, "쿼", "クォ"),
            (#line, "퀘", "クェ"),
            (#line, "퀴", "クィ"),
            (#line, "킈", "キ"),
            (#line, "타", "タ"),
            (#line, "탸", "ティャ"),
            (#line, "터", "ト"),
            (#line, "텨", "テョ"),
            (#line, "토", "ト"),
            (#line, "툐", "テョ"),
            (#line, "투", "トゥ"),
            (#line, "튜", "テュ"),
            (#line, "트", "トゥ"),
            (#line, "티", "ティ"),
            (#line, "태", "テ"),
            (#line, "턔", "テ"),
            (#line, "테", "テ"),
            (#line, "톄", "テ"),
            (#line, "톼", "トァ"),
            (#line, "퇘", "トェ"),
            (#line, "퇴", "トェ"),
            (#line, "퉈", "トォ"),
            (#line, "퉤", "トェ"),
            (#line, "튀", "トゥィ"),
            (#line, "틔", "トィ"),
            (#line, "파", "パ"),
            (#line, "퍄", "ピャ"),
            (#line, "퍼", "ポ"),
            (#line, "펴", "ピョ"),
            (#line, "포", "ポ"),
            (#line, "표", "ピョ"),
            (#line, "푸", "プ"),
            (#line, "퓨", "ピュ"),
            (#line, "프", "プ"),
            (#line, "피", "ピ"),
            (#line, "패", "ペ"),
            (#line, "퍠", "ペ"),
            (#line, "페", "ペ"),
            (#line, "폐", "ペ"),
            (#line, "퐈", "プァ"),
            (#line, "퐤", "プェ"),
            (#line, "푀", "プェ"),
            (#line, "풔", "プォ"),
            (#line, "풰", "プェ"),
            (#line, "퓌", "プィ"),
            (#line, "픠", "ピ"),
            (#line, "하", "ハ"),
            (#line, "햐", "ヒャ"),
            (#line, "허", "ホ"),
            (#line, "혀", "ヒョ"),
            (#line, "호", "ホ"),
            (#line, "효", "ヒョ"),
            (#line, "후", "フ"),
            (#line, "휴", "ヒュ"),
            (#line, "흐", "フ"),
            (#line, "히", "ヒ"),
            (#line, "해", "ヘ"),
            (#line, "햬", "ヘ"),
            (#line, "헤", "ヘ"),
            (#line, "혜", "ヘ"),
            (#line, "화", "ファ"),
            (#line, "홰", "フェ"),
            (#line, "회", "フェ"),
            (#line, "훠", "フォ"),
            (#line, "훼", "フェ"),
            (#line, "휘", "フィ"),
            (#line, "희", "ヒ"),
            (#line, "까", "ッカ"),
            (#line, "꺄", "ッキャ"),
            (#line, "꺼", "ッコ"),
            (#line, "껴", "ッキョ"),
            (#line, "꼬", "ッコ"),
            (#line, "꾜", "ッキョ"),
            (#line, "꾸", "ック"),
            (#line, "뀨", "ッキュ"),
            (#line, "끄", "ック"),
            (#line, "끼", "ッキ"),
            (#line, "깨", "ッケ"),
            (#line, "꺠", "ッケ"),
            (#line, "께", "ッケ"),
            (#line, "꼐", "ッケ"),
            (#line, "꽈", "ックァ"),
            (#line, "꽤", "ックェ"),
            (#line, "꾀", "ックェ"),
            (#line, "꿔", "ックォ"),
            (#line, "꿰", "ックェ"),
            (#line, "뀌", "ックィ"),
            (#line, "끠", "ッキ"),
            (#line, "따", "ッタ"),
            (#line, "땨", "ッティャ"),
            (#line, "떠", "ット"),
            (#line, "뗘", "ッテョ"),
            (#line, "또", "ット"),
            (#line, "뚀", "ッテョ"),
            (#line, "뚜", "ットゥ"),
            (#line, "뜌", "ッテュ"),
            (#line, "뜨", "ットゥ"),
            (#line, "띠", "ッティ"),
            (#line, "때", "ッテ"),
            (#line, "떄", "ッテ"),
            (#line, "떼", "ッテ"),
            (#line, "뗴", "ッテ"),
            (#line, "똬", "ットァ"),
            (#line, "뙈", "ットェ"),
            (#line, "뙤", "ットェ"),
            (#line, "뚸", "ットォ"),
            (#line, "뛔", "ットェ"),
            (#line, "뛰", "ットィ"),
            (#line, "띄", "ットィ"),
            (#line, "빠", "ッパ"),
            (#line, "뺘", "ッピャ"),
            (#line, "뻐", "ッポ"),
            (#line, "뼈", "ッピョ"),
            (#line, "뽀", "ッポ"),
            (#line, "뾰", "ッピョ"),
            (#line, "뿌", "ップ"),
            (#line, "쀼", "ッピュ"),
            (#line, "쁘", "ップ"),
            (#line, "삐", "ッピ"),
            (#line, "빼", "ッペ"),
            (#line, "뺴", "ッペ"),
            (#line, "뻬", "ッペ"),
            (#line, "뼤", "ッペ"),
            (#line, "뽜", "ップァ"),
            (#line, "뽸", "ップェ"),
            (#line, "뾔", "ップェ"),
            (#line, "뿨", "ップォ"),
            (#line, "쀄", "ップェ"),
            (#line, "쀠", "ップィ"),
            (#line, "쁴", "ッピ"),
            (#line, "싸", "ッサ"),
            (#line, "쌰", "ッシャ"),
            (#line, "써", "ッソ"),
            (#line, "쎠", "ッショ"),
            (#line, "쏘", "ッソ"),
            (#line, "쑈", "ッショ"),
            (#line, "쑤", "ッス"),
            (#line, "쓔", "ッシュ"),
            (#line, "쓰", "ッス"),
            (#line, "씨", "ッシ"),
            (#line, "쌔", "ッセ"),
            (#line, "썌", "ッセ"),
            (#line, "쎄", "ッセ"),
            (#line, "쎼", "ッセ"),
            (#line, "쏴", "ッスァ"),
            (#line, "쐐", "ッスェ"),
            (#line, "쐬", "ッスェ"),
            (#line, "쒀", "ッスォ"),
            (#line, "쒜", "ッスェ"),
            (#line, "쒸", "ッスィ"),
            (#line, "씌", "ッシ"),
            (#line, "짜", "ッチャ"),
            (#line, "쨔", "ッチャ"),
            (#line, "쩌", "ッチョ"),
            (#line, "쪄", "ッチョ"),
            (#line, "쪼", "ッチョ"),
            (#line, "쬬", "ッチョ"),
            (#line, "쭈", "ッチュ"),
            (#line, "쮸", "ッチュ"),
            (#line, "쯔", "ッチュ"),
            (#line, "찌", "ッチ"),
            (#line, "째", "ッチェ"),
            (#line, "쨰", "ッチェ"),
            (#line, "쩨", "ッチェ"),
            (#line, "쪠", "ッチェ"),
            (#line, "쫘", "ッチャ"),
            (#line, "쫴", "ッチェ"),
            (#line, "쬐", "ッチェ"),
            (#line, "쭤", "ッチョ"),
            (#line, "쮀", "ッチェ"),
            (#line, "쮜", "ッチィ"),
            (#line, "쯰", "ッチィ")
        ]
        for testCase in testCases {
            XCTAssertEqual(try HangulCharacter(testCase.1).katakanize(vocalize: false), testCase.2, line: testCase.0)
        }
    }

    func testKatakanize_finalConsonant() {
        let testCases: [(UInt, Character, String)] = [
            (#line, "먹", "モ(ク)"), // "ᆨ"
            (#line, "낚", "ナ(ク)"), // "ᆩ"
            (#line, "몫", "モ(ク)"), // "ᆪ"
            (#line, "관", "クァン"), // "ᆫ"
            (#line, "앉", "アン"), // "ᆬ"
            (#line, "많", "マン"), // "ᆭ"
            (#line, "받", "パッ"), // "ᆮ"
            (#line, "물", "ム(ル)"), // "ᆯ"
            (#line, "닭", "タ(ク)"), // "ᆰ"
            (#line, "젊", "チョ(ム)"), // "ᆱ"
            (#line, "넓", "ノ(ル)"), // "ᆲ"
            (#line, "곬", "コ(ル)"), // "ᆳ"
            (#line, "훑", "フ(ル)"), // "ᆴ"
            (#line, "읊", "ウ(プ)"), // "ᆵ"
            (#line, "싫", "シ(ル)"), // "ᆶ"
            (#line, "심", "シ(ム)"), // "ᆷ"
            (#line, "합", "ハ(プ)"), // "ᆸ"
            (#line, "없", "オ(プ)"), // "ᆹ"
            (#line, "것", "コッ"), // "ᆺ"
            (#line, "갰", "ケッ"), // "ᆻ"
            (#line, "횡", "フェン"), // "ᆼ"
            (#line, "맞", "マッ"), // "ᆽ"
            (#line, "꽃", "ッコッ"), // "ᆾ"
            (#line, "갘", "カ(ク)"), // "ᆿ"
            (#line, "겉", "コッ"), // "ᇀ"
            (#line, "걮", "ケ(プ)"), // "ᇁ"
            (#line, "좋", "チョッ") // "ᇂ"
        ]
        for testCase in testCases {
            XCTAssertEqual(try HangulCharacter(testCase.1).katakanize(vocalize: false), testCase.2, line: testCase.0)
        }
    }

    func testKatakanize_vocalize() {
        let testCases: [(UInt, Character, String)] = [
            (#line, "가", "ガ"),
            (#line, "갸", "ギャ"),
            (#line, "거", "ゴ"),
            (#line, "겨", "ギョ"),
            (#line, "고", "ゴ"),
            (#line, "교", "ギョ"),
            (#line, "구", "グ"),
            (#line, "규", "ギュ"),
            (#line, "그", "グ"),
            (#line, "기", "ギ"),
            (#line, "개", "ゲ"),
            (#line, "걔", "ゲ"),
            (#line, "게", "ゲ"),
            (#line, "계", "ゲ"),
            (#line, "과", "グァ"),
            (#line, "괘", "グェ"),
            (#line, "괴", "グェ"),
            (#line, "궈", "グォ"),
            (#line, "궤", "グェ"),
            (#line, "귀", "グィ"),
            (#line, "긔", "ギ"),
            (#line, "나", "ナ"),
            (#line, "냐", "ニャ"),
            (#line, "너", "ノ"),
            (#line, "녀", "ニョ"),
            (#line, "노", "ノ"),
            (#line, "뇨", "ニョ"),
            (#line, "누", "ヌ"),
            (#line, "뉴", "ニュ"),
            (#line, "느", "ヌ"),
            (#line, "니", "ニ"),
            (#line, "내", "ネ"),
            (#line, "냬", "ネ"),
            (#line, "네", "ネ"),
            (#line, "녜", "ネ"),
            (#line, "놔", "ヌァ"),
            (#line, "놰", "ヌェ"),
            (#line, "뇌", "ヌェ"),
            (#line, "눠", "ヌォ"),
            (#line, "눼", "ヌェ"),
            (#line, "뉘", "ヌィ"),
            (#line, "늬", "ニ"),
            (#line, "다", "ダ"),
            (#line, "댜", "ディャ"),
            (#line, "더", "ド"),
            (#line, "뎌", "デョ"),
            (#line, "도", "ド"),
            (#line, "됴", "デョ"),
            (#line, "두", "ドゥ"),
            (#line, "듀", "デュ"),
            (#line, "드", "ドゥ"),
            (#line, "디", "ディ"),
            (#line, "대", "デ"),
            (#line, "댸", "デ"),
            (#line, "데", "デ"),
            (#line, "뎨", "デ"),
            (#line, "돠", "ドァ"),
            (#line, "돼", "ドェ"),
            (#line, "되", "ドェ"),
            (#line, "둬", "ドォ"),
            (#line, "뒈", "ドェ"),
            (#line, "뒤", "ドィ"),
            (#line, "듸", "ディ"),
            (#line, "라", "ラ"),
            (#line, "랴", "リャ"),
            (#line, "러", "ロ"),
            (#line, "려", "リョ"),
            (#line, "로", "ロ"),
            (#line, "료", "リョ"),
            (#line, "루", "ル"),
            (#line, "류", "リュ"),
            (#line, "르", "ル"),
            (#line, "리", "リ"),
            (#line, "래", "レ"),
            (#line, "럐", "レ"),
            (#line, "레", "レ"),
            (#line, "례", "レ"),
            (#line, "롸", "ルァ"),
            (#line, "뢔", "ルェ"),
            (#line, "뢰", "ルェ"),
            (#line, "뤄", "ルォ"),
            (#line, "뤠", "ルェ"),
            (#line, "뤼", "ルィ"),
            (#line, "릐", "リ"),
            (#line, "마", "マ"),
            (#line, "먀", "ミャ"),
            (#line, "머", "モ"),
            (#line, "며", "ミョ"),
            (#line, "모", "モ"),
            (#line, "묘", "ミョ"),
            (#line, "무", "ム"),
            (#line, "뮤", "ミュ"),
            (#line, "므", "ム"),
            (#line, "미", "ミ"),
            (#line, "매", "メ"),
            (#line, "먜", "メ"),
            (#line, "메", "メ"),
            (#line, "몌", "メ"),
            (#line, "뫄", "ムァ"),
            (#line, "뫠", "ムェ"),
            (#line, "뫼", "ムェ"),
            (#line, "뭐", "ムォ"),
            (#line, "뭬", "ムェ"),
            (#line, "뮈", "ムィ"),
            (#line, "믜", "ミ"),
            (#line, "바", "バ"),
            (#line, "뱌", "ビャ"),
            (#line, "버", "ボ"),
            (#line, "벼", "ビョ"),
            (#line, "보", "ボ"),
            (#line, "뵤", "ビョ"),
            (#line, "부", "ブ"),
            (#line, "뷰", "ビュ"),
            (#line, "브", "ブ"),
            (#line, "비", "ビ"),
            (#line, "배", "ベ"),
            (#line, "뱨", "ベ"),
            (#line, "베", "ベ"),
            (#line, "볘", "ベ"),
            (#line, "봐", "ブァ"),
            (#line, "봬", "ブェ"),
            (#line, "뵈", "ブェ"),
            (#line, "붜", "ボォ"),
            (#line, "붸", "ブェ"),
            (#line, "뷔", "ブィ"),
            (#line, "븨", "ビ"),
            (#line, "사", "サ"),
            (#line, "샤", "シャ"),
            (#line, "서", "ソ"),
            (#line, "셔", "ショ"),
            (#line, "소", "ソ"),
            (#line, "쇼", "ショ"),
            (#line, "수", "ス"),
            (#line, "슈", "シュ"),
            (#line, "스", "ス"),
            (#line, "시", "シ"),
            (#line, "새", "セ"),
            (#line, "섀", "セ"),
            (#line, "세", "セ"),
            (#line, "셰", "セ"),
            (#line, "솨", "スァ"),
            (#line, "쇄", "スェ"),
            (#line, "쇠", "スェ"),
            (#line, "숴", "スォ"),
            (#line, "쉐", "スェ"),
            (#line, "쉬", "スィ"),
            (#line, "싀", "シ"),
            (#line, "아", "ア"),
            (#line, "야", "ヤ"),
            (#line, "어", "オ"),
            (#line, "여", "ヨ"),
            (#line, "오", "オ"),
            (#line, "요", "ヨ"),
            (#line, "우", "ウ"),
            (#line, "유", "ユ"),
            (#line, "으", "ウ"),
            (#line, "이", "イ"),
            (#line, "애", "エ"),
            (#line, "얘", "イェ"),
            (#line, "에", "エ"),
            (#line, "예", "イェ"),
            (#line, "와", "ワ"),
            (#line, "왜", "ウェ"),
            (#line, "외", "ウェ"),
            (#line, "워", "ウォ"),
            (#line, "웨", "ウェ"),
            (#line, "위", "ウィ"),
            (#line, "의", "ウィ"),
            (#line, "자", "ジャ"),
            (#line, "쟈", "ジャ"),
            (#line, "저", "ジョ"),
            (#line, "져", "ジョ"),
            (#line, "조", "ジョ"),
            (#line, "죠", "ジョ"),
            (#line, "주", "ジュ"),
            (#line, "쥬", "ジュ"),
            (#line, "즈", "ジュ"),
            (#line, "지", "ジ"),
            (#line, "재", "ジェ"),
            (#line, "쟤", "ジェ"),
            (#line, "제", "ジェ"),
            (#line, "졔", "ジェ"),
            (#line, "좌", "ジュァ"),
            (#line, "좨", "ジュェ"),
            (#line, "죄", "ジェ"),
            (#line, "줘", "ジョ"),
            (#line, "줴", "ジェ"),
            (#line, "쥐", "ジュィ"),
            (#line, "즤", "ジィ"),
            (#line, "차", "チャ"),
            (#line, "챠", "チャ"),
            (#line, "처", "チョ"),
            (#line, "쳐", "チョ"),
            (#line, "초", "チョ"),
            (#line, "쵸", "チョ"),
            (#line, "추", "チュ"),
            (#line, "츄", "チュ"),
            (#line, "츠", "チュ"),
            (#line, "치", "チ"),
            (#line, "채", "チェ"),
            (#line, "챼", "チェ"),
            (#line, "체", "チェ"),
            (#line, "쳬", "チェ"),
            (#line, "촤", "チュァ"),
            (#line, "쵀", "チュェ"),
            (#line, "최", "チェ"),
            (#line, "춰", "チョ"),
            (#line, "췌", "チェ"),
            (#line, "취", "チュィ"),
            (#line, "츼", "チィ"),
            (#line, "카", "カ"),
            (#line, "캬", "キャ"),
            (#line, "커", "コ"),
            (#line, "켜", "キョ"),
            (#line, "코", "コ"),
            (#line, "쿄", "キョ"),
            (#line, "쿠", "ク"),
            (#line, "큐", "キュ"),
            (#line, "크", "ク"),
            (#line, "키", "キ"),
            (#line, "캐", "ケ"),
            (#line, "컈", "ケ"),
            (#line, "케", "ケ"),
            (#line, "켸", "ケ"),
            (#line, "콰", "クァ"),
            (#line, "쾌", "クェ"),
            (#line, "쾨", "クェ"),
            (#line, "쿼", "クォ"),
            (#line, "퀘", "クェ"),
            (#line, "퀴", "クィ"),
            (#line, "킈", "キ"),
            (#line, "타", "タ"),
            (#line, "탸", "ティャ"),
            (#line, "터", "ト"),
            (#line, "텨", "テョ"),
            (#line, "토", "ト"),
            (#line, "툐", "テョ"),
            (#line, "투", "トゥ"),
            (#line, "튜", "テュ"),
            (#line, "트", "トゥ"),
            (#line, "티", "ティ"),
            (#line, "태", "テ"),
            (#line, "턔", "テ"),
            (#line, "테", "テ"),
            (#line, "톄", "テ"),
            (#line, "톼", "トァ"),
            (#line, "퇘", "トェ"),
            (#line, "퇴", "トェ"),
            (#line, "퉈", "トォ"),
            (#line, "퉤", "トェ"),
            (#line, "튀", "トゥィ"),
            (#line, "틔", "トィ"),
            (#line, "파", "パ"),
            (#line, "퍄", "ピャ"),
            (#line, "퍼", "ポ"),
            (#line, "펴", "ピョ"),
            (#line, "포", "ポ"),
            (#line, "표", "ピョ"),
            (#line, "푸", "プ"),
            (#line, "퓨", "ピュ"),
            (#line, "프", "プ"),
            (#line, "피", "ピ"),
            (#line, "패", "ペ"),
            (#line, "퍠", "ペ"),
            (#line, "페", "ペ"),
            (#line, "폐", "ペ"),
            (#line, "퐈", "プァ"),
            (#line, "퐤", "プェ"),
            (#line, "푀", "プェ"),
            (#line, "풔", "プォ"),
            (#line, "풰", "プェ"),
            (#line, "퓌", "プィ"),
            (#line, "픠", "ピ"),
            (#line, "하", "ハ"),
            (#line, "햐", "ヒャ"),
            (#line, "허", "ホ"),
            (#line, "혀", "ヒョ"),
            (#line, "호", "ホ"),
            (#line, "효", "ヒョ"),
            (#line, "후", "フ"),
            (#line, "휴", "ヒュ"),
            (#line, "흐", "フ"),
            (#line, "히", "ヒ"),
            (#line, "해", "ヘ"),
            (#line, "햬", "ヘ"),
            (#line, "헤", "ヘ"),
            (#line, "혜", "ヘ"),
            (#line, "화", "ファ"),
            (#line, "홰", "フェ"),
            (#line, "회", "フェ"),
            (#line, "훠", "フォ"),
            (#line, "훼", "フェ"),
            (#line, "휘", "フィ"),
            (#line, "희", "ヒ"),
            (#line, "까", "ッカ"),
            (#line, "꺄", "ッキャ"),
            (#line, "꺼", "ッコ"),
            (#line, "껴", "ッキョ"),
            (#line, "꼬", "ッコ"),
            (#line, "꾜", "ッキョ"),
            (#line, "꾸", "ック"),
            (#line, "뀨", "ッキュ"),
            (#line, "끄", "ック"),
            (#line, "끼", "ッキ"),
            (#line, "깨", "ッケ"),
            (#line, "꺠", "ッケ"),
            (#line, "께", "ッケ"),
            (#line, "꼐", "ッケ"),
            (#line, "꽈", "ックァ"),
            (#line, "꽤", "ックェ"),
            (#line, "꾀", "ックェ"),
            (#line, "꿔", "ックォ"),
            (#line, "꿰", "ックェ"),
            (#line, "뀌", "ックィ"),
            (#line, "끠", "ッキ"),
            (#line, "따", "ッタ"),
            (#line, "땨", "ッティャ"),
            (#line, "떠", "ット"),
            (#line, "뗘", "ッテョ"),
            (#line, "또", "ット"),
            (#line, "뚀", "ッテョ"),
            (#line, "뚜", "ットゥ"),
            (#line, "뜌", "ッテュ"),
            (#line, "뜨", "ットゥ"),
            (#line, "띠", "ッティ"),
            (#line, "때", "ッテ"),
            (#line, "떄", "ッテ"),
            (#line, "떼", "ッテ"),
            (#line, "뗴", "ッテ"),
            (#line, "똬", "ットァ"),
            (#line, "뙈", "ットェ"),
            (#line, "뙤", "ットェ"),
            (#line, "뚸", "ットォ"),
            (#line, "뛔", "ットェ"),
            (#line, "뛰", "ットィ"),
            (#line, "띄", "ットィ"),
            (#line, "빠", "ッパ"),
            (#line, "뺘", "ッピャ"),
            (#line, "뻐", "ッポ"),
            (#line, "뼈", "ッピョ"),
            (#line, "뽀", "ッポ"),
            (#line, "뾰", "ッピョ"),
            (#line, "뿌", "ップ"),
            (#line, "쀼", "ッピュ"),
            (#line, "쁘", "ップ"),
            (#line, "삐", "ッピ"),
            (#line, "빼", "ッペ"),
            (#line, "뺴", "ッペ"),
            (#line, "뻬", "ッペ"),
            (#line, "뼤", "ッペ"),
            (#line, "뽜", "ップァ"),
            (#line, "뽸", "ップェ"),
            (#line, "뾔", "ップェ"),
            (#line, "뿨", "ップォ"),
            (#line, "쀄", "ップェ"),
            (#line, "쀠", "ップィ"),
            (#line, "쁴", "ッピ"),
            (#line, "싸", "ッサ"),
            (#line, "쌰", "ッシャ"),
            (#line, "써", "ッソ"),
            (#line, "쎠", "ッショ"),
            (#line, "쏘", "ッソ"),
            (#line, "쑈", "ッショ"),
            (#line, "쑤", "ッス"),
            (#line, "쓔", "ッシュ"),
            (#line, "쓰", "ッス"),
            (#line, "씨", "ッシ"),
            (#line, "쌔", "ッセ"),
            (#line, "썌", "ッセ"),
            (#line, "쎄", "ッセ"),
            (#line, "쎼", "ッセ"),
            (#line, "쏴", "ッスァ"),
            (#line, "쐐", "ッスェ"),
            (#line, "쐬", "ッスェ"),
            (#line, "쒀", "ッスォ"),
            (#line, "쒜", "ッスェ"),
            (#line, "쒸", "ッスィ"),
            (#line, "씌", "ッシ"),
            (#line, "짜", "ッチャ"),
            (#line, "쨔", "ッチャ"),
            (#line, "쩌", "ッチョ"),
            (#line, "쪄", "ッチョ"),
            (#line, "쪼", "ッチョ"),
            (#line, "쬬", "ッチョ"),
            (#line, "쭈", "ッチュ"),
            (#line, "쮸", "ッチュ"),
            (#line, "쯔", "ッチュ"),
            (#line, "찌", "ッチ"),
            (#line, "째", "ッチェ"),
            (#line, "쨰", "ッチェ"),
            (#line, "쩨", "ッチェ"),
            (#line, "쪠", "ッチェ"),
            (#line, "쫘", "ッチャ"),
            (#line, "쫴", "ッチェ"),
            (#line, "쬐", "ッチェ"),
            (#line, "쭤", "ッチョ"),
            (#line, "쮀", "ッチェ"),
            (#line, "쮜", "ッチィ"),
            (#line, "쯰", "ッチィ")
        ]
        for testCase in testCases {
            XCTAssertEqual(try HangulCharacter(testCase.1).katakanize(vocalize: true), testCase.2, line: testCase.0)
        }
    }
}
