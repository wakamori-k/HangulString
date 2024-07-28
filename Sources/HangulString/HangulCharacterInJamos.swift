//
//  HangulCharacterInJamos.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/12.
//

/// A hangul character represented in Jamo sequences.
struct HangulCharacterInJamos {

    /// Jamo sequence of the initial consonant of the character
    let initialConsonant: [ConsonantJamo]

    /// Jamo  of the vowel of the character
    let vowel: VowelJamo

    /// Jamo sequence of the final consonant of the character.
    /// If the character does not have final consonant, the value shall be emptry.
    let finalConsonant: [ConsonantJamo]

    private let jamoScalars: [UnicodeHangulJamoScalar]

    /// Create a new object of ``HangulCharacterInJamos``
    /// - Parameters:
    ///   - initialConsonant: Jamos of the initial consonant.
    ///   - vowel: Jamo of the vowel
    ///   - finalConsonant: Jamos of the final consonant.
    init(initialConsonant: [ConsonantJamo], vowel: VowelJamo, finalConsonant: [ConsonantJamo] = []) {
        precondition(initialConsonant.count > 0, "initial consonant shall not be empty.")

        guard let initialConsonantScalar = try? UnicodeHangulJamoScalar(
                jamos: initialConsonant,
                firstConsonant: true) else {
            preconditionFailure("Invalid initialConsonant.")
        }
        let vowelScalar = UnicodeHangulJamoScalar(jamos: [vowel])

        var scalars = [initialConsonantScalar, vowelScalar]

        if finalConsonant.count > 0 {
            guard let finalConsonantScalar = try? UnicodeHangulJamoScalar(
                    jamos: finalConsonant,
                    firstConsonant: false) else {
                preconditionFailure("Invalid finalConsonant.")
            }
            scalars.append(finalConsonantScalar)
        }
        self.jamoScalars = scalars

        self.initialConsonant = initialConsonant
        self.vowel = vowel
        self.finalConsonant = finalConsonant
    }

    /// Convert to a sequence of ``UnicodeHangulJamoScalar``.
    func toJamoScalars() -> [UnicodeHangulJamoScalar] {
        return jamoScalars
    }

    /// Converts the  character to its Katakana representation.
    ///
    /// This method converts the current Hangul character into its corresponding Katakana representation.
    /// It also considers whether the character should be vocalized and appends the appropriate Katakana
    /// for any final consonants.
    ///
    /// - Parameter vocalize: A Boolean value indicating whether the character should be vocalized.
    /// - Returns: A `String` containing the Katakana representation of the Hangul character.
    /// - Note: This method assumes that the `initialConsonant` and `vowel` properties are
    /// correctly mapped to their Katakana equivalents. It also handles specific cases where the Katakana
    /// representation needs to be adjusted based on the initial consonant.
    func katakanize(vocalize: Bool) -> String {
        guard var katakanized = Self.initialConsonantAndVowelToKatakana[initialConsonant]?[vowel]  else {
            fatalError("Unreachable.")
        }

        if vocalize && initialConsonant.count == 1 {
            switch self.initialConsonant[0] {
            case .bieup:
                katakanized = katakanized.replacingOccurrences(of: "\u{309A}", with: "\u{3099}")
            case .giyeok, .digeut:
                katakanized.insert(contentsOf: "\u{3099}",
                                   at: katakanized.index(katakanized.startIndex, offsetBy: 1))
            case .jieut:
                katakanized = katakanized.replacingOccurrences(of: "チ", with: "ジ")
            default: break
            }
        }

        if finalConsonant.count > 0 {
            guard let fckana = Self.finalConsonantToKatakana[finalConsonant] else {
                fatalError("Unreachable.")
            }
            katakanized += fckana
        }

        return katakanized
    }

}

extension HangulCharacterInJamos: Equatable {
    static func == (lhs: HangulCharacterInJamos, rhs: HangulCharacterInJamos) -> Bool {
        return
            lhs.initialConsonant == rhs.initialConsonant &&
            lhs.vowel == rhs.vowel &&
            lhs.finalConsonant == rhs.finalConsonant
    }
}

extension HangulCharacterInJamos {
    /// Mapping from a pair of initial consonant and vowel to Katakana.
    ///
    /// Refernce: https://trilingual.jp/wp-content/uploads/2019/03/hangul.pdf
    static let initialConsonantAndVowelToKatakana: [[ConsonantJamo]: [VowelJamo: String]] = [
        [.giyeok]: [
            .a: "カ", // 가
            .ya: "キャ", // 갸
            .eo: "コ", // 거
            .yeo: "キョ", // 겨
            .o: "コ", // 고
            .yo: "キョ", // 교
            .u: "ク", // 구
            .yu: "キュ", // 규
            .eu: "ク", // 그
            .i: "キ", // 기
            .ae: "ケ", // 개
            .yae: "ケ", // 걔
            .e: "ケ", // 게
            .ye: "ケ", // 계
            .wa: "クァ", // 과
            .wae: "クェ", // 괘
            .oe: "クェ", // 괴
            .wo: "クォ", // 궈
            .we: "クェ", // 궤
            .wi: "クィ", // 귀
            .ui: "キ" // 긔
        ],
        [.giyeok, .giyeok]: [
            .a: "ッカ", // 까
            .ya: "ッキャ", // 꺄
            .eo: "ッコ", // 꺼
            .yeo: "ッキョ", // 껴
            .o: "ッコ", // 꼬
            .yo: "ッキョ", // 꾜
            .u: "ック", // 꾸
            .yu: "ッキュ", // 뀨
            .eu: "ック", // 끄
            .i: "ッキ", // 끼
            .ae: "ッケ", // 깨
            .yae: "ッケ", // 꺠
            .e: "ッケ", // 께
            .ye: "ッケ", // 꼐
            .wa: "ックァ", // 꽈
            .wae: "ックェ", // 꽤
            .oe: "ックェ", // 꾀
            .wo: "ックォ", // 꿔
            .we: "ックェ", // 꿰
            .wi: "ックィ", // 뀌
            .ui: "ッキ" // 끠
        ],
        [.nieun]: [
            .a: "ナ", // 나
            .ya: "ニャ", // 냐
            .eo: "ノ", // 너
            .yeo: "ニョ", // 녀
            .o: "ノ", // 노
            .yo: "ニョ", // 뇨
            .u: "ヌ", // 누
            .yu: "ニュ", // 뉴
            .eu: "ヌ", // 느
            .i: "ニ", // 니
            .ae: "ネ", // 내
            .yae: "ネ", // 냬
            .e: "ネ", // 네
            .ye: "ネ", // 녜
            .wa: "ヌァ", // 놔
            .wae: "ヌェ", // 놰
            .oe: "ヌェ", // 뇌
            .wo: "ヌォ", // 눠
            .we: "ヌェ", // 눼
            .wi: "ヌィ", // 뉘
            .ui: "ニ" // 늬
        ],
        [.digeut]: [
            .a: "タ", // 다
            .ya: "ティャ", // 댜
            .eo: "ト", // 더
            .yeo: "テョ", // 뎌
            .o: "ト", // 도
            .yo: "テョ", // 됴
            .u: "トゥ", // 두
            .yu: "テュ", // 듀
            .eu: "トゥ", // 드
            .i: "ティ", // 디
            .ae: "テ", // 대
            .yae: "テ", // 댸
            .e: "テ", // 데
            .ye: "テ", // 뎨
            .wa: "トァ", // 돠
            .wae: "トェ", // 돼
            .oe: "トェ", // 되
            .wo: "トォ", // 둬
            .we: "トェ", // 뒈
            .wi: "トィ", // 뒤
            .ui: "ティ" // 듸
        ],
        [.digeut, .digeut]: [
            .a: "ッタ", // 따
            .ya: "ッティャ", // 땨
            .eo: "ット", // 떠
            .yeo: "ッテョ", // 뗘
            .o: "ット", // 또
            .yo: "ッテョ", // 뚀
            .u: "ットゥ", // 뚜
            .yu: "ッテュ", // 뜌
            .eu: "ットゥ", // 뜨
            .i: "ッティ", // 띠
            .ae: "ッテ", // 때
            .yae: "ッテ", // 떄
            .e: "ッテ", // 떼
            .ye: "ッテ", // 뗴
            .wa: "ットァ", // 똬
            .wae: "ットェ", // 뙈
            .oe: "ットェ", // 뙤
            .wo: "ットォ", // 뚸
            .we: "ットェ", // 뛔
            .wi: "ットィ", // 뛰
            .ui: "ットィ" // 띄
        ],
        [.rieul]: [
            .a: "ラ", // 라
            .ya: "リャ", // 랴
            .eo: "ロ", // 러
            .yeo: "リョ", // 려
            .o: "ロ", // 로
            .yo: "リョ", // 료
            .u: "ル", // 루
            .yu: "リュ", // 류
            .eu: "ル", // 르
            .i: "リ", // 리
            .ae: "レ", // 래
            .yae: "レ", // 랴
            .e: "レ", // 레
            .ye: "レ", // 례
            .wa: "ルァ", // 롸
            .wae: "ルェ", // 뢔
            .oe: "ルェ", // 뢰
            .wo: "ルォ", // 뤄
            .we: "ルェ", // 뤠
            .wi: "ルィ", // 뤼
            .ui: "リ" // 릐
        ],
        [.mieum]: [
            .a: "マ", // 마
            .ya: "ミャ", // 먀
            .eo: "モ", // 머
            .yeo: "ミョ", // 며
            .o: "モ", // 모
            .yo: "ミョ", // 묘
            .u: "ム", // 무
            .yu: "ミュ", // 뮤
            .eu: "ム", // 므
            .i: "ミ", // 미
            .ae: "メ", // 매
            .yae: "メ", // 먜
            .e: "メ", // 메
            .ye: "メ", // 몌
            .wa: "ムァ", // 뫄
            .wae: "ムェ", // 뫠
            .oe: "ムェ", // 뫼
            .wo: "ムォ", // 뭐
            .we: "ムェ", // 뭬
            .wi: "ムィ", // 뮈
            .ui: "ミ" // 믜
        ],
        [.bieup]: [
            .a: "ハ\u{309A}", // 바
            .ya: "ヒ\u{309A}ャ", // 뱌
            .eo: "ホ\u{309A}", // 버
            .yeo: "ヒ\u{309A}ョ", // 벼
            .o: "ホ\u{309A}", // 보
            .yo: "ヒ\u{309A}ョ", // 뵤
            .u: "フ\u{309A}", // 부
            .yu: "ヒ\u{309A}ュ", // 뷰
            .eu: "フ\u{309A}", // 브
            .i: "ヒ\u{309A}", // 비
            .ae: "ヘ\u{309A}", // 배
            .yae: "ヘ\u{309A}", // 뱨
            .e: "ヘ\u{309A}", // 베
            .ye: "ヘ\u{309A}", // 볘
            .wa: "フ\u{309A}ァ", // 봐
            .wae: "フ\u{309A}ェ", // 봬
            .oe: "フ\u{309A}ェ", // 뵈
            .wo: "ホ\u{309A}ォ", // 붜
            .we: "フ\u{309A}ェ", // 붸
            .wi: "フ\u{309A}ィ", // 뷔
            .ui: "ヒ\u{309A}" // 븨
        ],
        [.bieup, .bieup]: [
            .a: "ッパ", // 빠
            .ya: "ッピャ", // 뺘
            .eo: "ッポ", // 뻐
            .yeo: "ッピョ", // 뼈
            .o: "ッポ", // 뽀
            .yo: "ッピョ", // 뾰
            .u: "ップ", // 뿌
            .yu: "ッピュ", // 쀼
            .eu: "ップ", // 쁘
            .i: "ッピ", // 삐
            .ae: "ッペ", // 빼
            .yae: "ッペ", // 뺴
            .e: "ッペ", // 뻬
            .ye: "ッペ", // 뼤
            .wa: "ップァ", // 뽜
            .wae: "ップェ", // 뽸
            .oe: "ップェ", // 뾔
            .wo: "ップォ", // 뿨
            .we: "ップェ", // 쀄
            .wi: "ップィ", // 쀠
            .ui: "ッピ" // 쁴
        ],
        [.siot]: [
            .a: "サ", // 사
            .ya: "シャ", // 샤
            .eo: "ソ", // 서
            .yeo: "ショ", // 셔
            .o: "ソ", // 소
            .yo: "ショ", // 쇼
            .u: "ス", // 수
            .yu: "シュ", // 슈
            .eu: "ス", // 스
            .i: "シ", // 시
            .ae: "セ", // 새
            .yae: "セ", // 섀
            .e: "セ", // 세
            .ye: "セ", // 셰
            .wa: "スァ", // 솨
            .wae: "スェ", // 쇄
            .oe: "スェ", // 쇠
            .wo: "スォ", // 숴
            .we: "スェ", // 쉐
            .wi: "スィ", // 쉬
            .ui: "シ" // 싀
        ],
        [.siot, .siot]: [
            .a: "ッサ", // 싸
            .ya: "ッシャ", // 쌰
            .eo: "ッソ", // 써
            .yeo: "ッショ", // 쎠
            .o: "ッソ", // 쏘
            .yo: "ッショ", // 쑈
            .u: "ッス", // 쑤
            .yu: "ッシュ", // 쓔
            .eu: "ッス", // 쓰
            .i: "ッシ", // 씨
            .ae: "ッセ", // 쌔
            .yae: "ッセ", // 썌
            .e: "ッセ", // 쎄
            .ye: "ッセ", // 쎼
            .wa: "ッスァ", // 쏴
            .wae: "ッスェ", // 쐐
            .oe: "ッスェ", // 쐬
            .wo: "ッスォ", // 쒀
            .we: "ッスェ", // 쒜
            .wi: "ッスィ", // 쒸
            .ui: "ッシ" // 씌
        ],
        [.ieung]: [
            .a: "ア", // 아
            .ya: "ヤ", // 야
            .eo: "オ", // 어
            .yeo: "ヨ", // 여
            .o: "オ", // 오
            .yo: "ヨ", // 요
            .u: "ウ", // 우
            .yu: "ユ", // 유
            .eu: "ウ", // 으
            .i: "イ", // 이
            .ae: "エ", // 애
            .yae: "イェ", // 얘
            .e: "エ", // 에
            .ye: "イェ", // 예
            .wa: "ワ", // 와
            .wae: "ウェ", // 왜
            .oe: "ウェ", // 외
            .wo: "ウォ", // 워
            .we: "ウェ", // 웨
            .wi: "ウィ", // 위
            .ui: "ウィ" // 의
        ],
        [.jieut]: [
            .a: "チャ", // 자
            .ya: "チャ", // 쟈
            .eo: "チョ", // 저
            .yeo: "チョ", // 져
            .o: "チョ", // 조
            .yo: "チョ", // 죠
            .u: "チュ", // 주
            .yu: "チュ", // 쥬
            .eu: "チュ", // 즈
            .i: "チ", // 지
            .ae: "チェ", // 재
            .yae: "チェ", // 쟤
            .e: "チェ", // 제
            .ye: "チェ", // 졔
            .wa: "チュァ", // 좌
            .wae: "チュェ", // 좨
            .oe: "チェ", // 죄
            .wo: "チョ", // 줘
            .we: "チェ", // 줴
            .wi: "チュィ", // 쥐
            .ui: "チィ" // 즤
        ],
        [.jieut, .jieut]: [
            .a: "ッチャ", // 짜
            .ya: "ッチャ", // 쨔
            .eo: "ッチョ", // 쩌
            .yeo: "ッチョ", // 쪄
            .o: "ッチョ", // 쪼
            .yo: "ッチョ", // 쬬
            .u: "ッチュ", // 쭈
            .yu: "ッチュ", // 쮸
            .eu: "ッチュ", // 쯔
            .i: "ッチ", // 찌
            .ae: "ッチェ", // 째
            .yae: "ッチェ", // 쨰
            .e: "ッチェ", // 쩨
            .ye: "ッチェ", // 쪠
            .wa: "ッチャ", // 쫘
            .wae: "ッチェ", // 쫴
            .oe: "ッチェ", // 쬐
            .wo: "ッチョ", // 쭤
            .we: "ッチェ", // 쮀
            .wi: "ッチィ", // 쮜
            .ui: "ッチィ" // 쯰
        ],
        [.chieut]: [
            .a: "チャ", // 차
            .ya: "チャ", // 챠
            .eo: "チョ", // 처
            .yeo: "チョ", // 쳐
            .o: "チョ", // 초
            .yo: "チョ", // 쵸
            .u: "チュ", // 추
            .yu: "チュ", // 츄
            .eu: "チュ", // 츠
            .i: "チ", // 치
            .ae: "チェ", // 채
            .yae: "チェ", // 챼
            .e: "チェ", // 체
            .ye: "チェ", // 쳬
            .wa: "チュァ", // 촤
            .wae: "チュェ", // 쵀
            .oe: "チェ", // 최
            .wo: "チョ", // 춰
            .we: "チェ", // 췌
            .wi: "チュィ", // 취
            .ui: "チィ" // 츼
        ],
        [.kieuk]: [
            .a: "カ", // 카
            .ya: "キャ", // 캬
            .eo: "コ", // 커
            .yeo: "キョ", // 켜
            .o: "コ", // 코
            .yo: "キョ", // 쿄
            .u: "ク", // 쿠
            .yu: "キュ", // 큐
            .eu: "ク", // 크
            .i: "キ", // 키
            .ae: "ケ", // 캐
            .yae: "ケ", // 컈
            .e: "ケ", // 케
            .ye: "ケ", // 켸
            .wa: "クァ", // 콰
            .wae: "クェ", // 쾌
            .oe: "クェ", // 쾨
            .wo: "クォ", // 쿼
            .we: "クェ", // 퀘
            .wi: "クィ", // 퀴
            .ui: "キ" // 킈
        ],
        [.tieut]: [
            .a: "タ", // 타
            .ya: "ティャ", // 탸
            .eo: "ト", // 터
            .yeo: "テョ", // 텨
            .o: "ト", // 토
            .yo: "テョ", // 툐
            .u: "トゥ", // 투
            .yu: "テュ", // 튜
            .eu: "トゥ", // 트
            .i: "ティ", // 티
            .ae: "テ", // 태
            .yae: "テ", // 턔
            .e: "テ", // 테
            .ye: "テ", // 톄
            .wa: "トァ", // 톼
            .wae: "トェ", // 퇘
            .oe: "トェ", // 퇴
            .wo: "トォ", // 퉈
            .we: "トェ", // 퉤
            .wi: "トゥィ", // 튀
            .ui: "トィ" // 틔
        ],
        [.pieup]: [
            .a: "パ", // 파
            .ya: "ピャ", // 퍄
            .eo: "ポ", // 퍼
            .yeo: "ピョ", // 펴
            .o: "ポ", // 포
            .yo: "ピョ", // 표
            .u: "プ", // 푸
            .yu: "ピュ", // 퓨
            .eu: "プ", // 프
            .i: "ピ", // 피
            .ae: "ペ", // 패
            .yae: "ペ", // 퍠
            .e: "ペ", // 페
            .ye: "ペ", // 폐
            .wa: "プァ", // 퐈
            .wae: "プェ", // 퐤
            .oe: "プェ", // 푀
            .wo: "プォ", // 풔
            .we: "プェ", // 풰
            .wi: "プィ", // 퓌
            .ui: "ピ" // 픠
        ],
        [.hieut]: [
            .a: "ハ", // 하
            .ya: "ヒャ", // 햐
            .eo: "ホ", // 허
            .yeo: "ヒョ", // 혀
            .o: "ホ", // 호
            .yo: "ヒョ", // 효
            .u: "フ", // 후
            .yu: "ヒュ", // 휴
            .eu: "フ", // 흐
            .i: "ヒ", // 히
            .ae: "ヘ", // 해
            .yae: "ヘ", // 햬
            .e: "ヘ", // 헤
            .ye: "ヘ", // 혜
            .wa: "ファ", // 화
            .wae: "フェ", // 홰
            .oe: "フェ", // 회
            .wo: "フォ", // 훠
            .we: "フェ", // 훼
            .wi: "フィ", // 휘
            .ui: "ヒ" // 희
        ]
    ]

    /// Mapping from final consonant to Katakana
    static let finalConsonantToKatakana: [[ConsonantJamo]: String] = [
        [.giyeok]: "(ク)", // "ᆨ"
        [.giyeok, .giyeok]: "(ク)", // "ᆩ"
        [.giyeok, .siot]: "(ク)", // "ᆪ"
        [.nieun]: "ン", // "ᆫ"
        [.nieun, .jieut]: "ン", // "ᆬ"
        [.nieun, .hieut]: "ン", // "ᆭ"
        [.digeut]: "ッ", // "ᆮ"
        [.rieul]: "(ル)", // "ᆯ"
        [.rieul, .giyeok]: "(ク)", // "ᆰ"
        [.rieul, .mieum]: "(ム)", // "ᆱ"
        [.rieul, .bieup]: "(ル)", // "ᆲ"
        [.rieul, .siot]: "(ル)", // "ᆳ"
        [.rieul, .tieut]: "(ル)", // "ᆴ"
        [.rieul, .pieup]: "(プ)", // "ᆵ"
        [.rieul, .hieut]: "(ル)", // "ᆶ"
        [.mieum]: "(ム)", // "ᆷ"
        [.bieup]: "(プ)", // "ᆸ"
        [.bieup, .siot]: "(プ)", // "ᆹ"
        [.siot]: "ッ", // "ᆺ"
        [.siot, .siot]: "ッ", // "ᆻ"
        [.ieung]: "ン", // "ᆼ"
        [.jieut]: "ッ", // "ᆽ"
        [.chieut]: "ッ", // "ᆾ"
        [.kieuk]: "(ク)", // "ᆿ"
        [.tieut]: "ッ", // "ᇀ"
        [.pieup]: "(プ)", // "ᇁ"
        [.hieut]: "ッ" // "ᇂ"
    ]
}
