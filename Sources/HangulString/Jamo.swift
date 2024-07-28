//
//  Jamo.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/06.
//

import Foundation

///
protocol Jamo {
    var isVowel: Bool { get }
    var isConsonant: Bool { get }
}

/// Enumeration of jamo of hangul consonants.
enum ConsonantJamo: Jamo {
    // Consonants
    case giyeok // "ㄱ" - 기역
    case nieun  // "ㄴ" - 니은
    case digeut // "ㄷ" - 디귿
    case rieul  // "ㄹ" - 리을
    case mieum  // "ㅁ" - 미음
    case bieup  // "ㅂ" - 비읍
    case siot   // "ㅅ" - 시옷
    case ieung  // "ㅇ" - 이응
    case jieut  // "ㅈ" - 지읒
    case chieut // "ㅊ" - 치읓
    case kieuk  // "ㅋ" - 키읔
    case tieut  // "ㅌ" - 티읕
    case pieup  // "ㅍ" - 피읖
    case hieut  // "ㅎ" - 히읗

    var isVowel: Bool { false }
    var isConsonant: Bool { true }
}

/// Enumeration of jamo of hangul vowels.
enum VowelJamo: Jamo {
    case a   // "ㅏ"
    case ya  // "ㅑ"
    case eo  // "ㅓ"
    case yeo // "ㅕ"
    case o   // "ㅗ"
    case yo  // "ㅛ"
    case u   // "ㅜ"
    case yu  // "ㅠ"
    case eu  // "ㅡ"
    case i   // "ㅣ"
    case ae  // "ㅐ"
    case yae // "ㅒ"
    case e   // "ㅔ"
    case ye  // "ㅖ"
    case wa  // "ㅘ"
    case wae // "ㅙ"
    case oe  // "ㅚ"
    case wo  // "ㅝ"
    case we  // "ㅞ"
    case wi  // "ㅟ"
    case ui  // "ㅢ"

    var isVowel: Bool { true }
    var isConsonant: Bool { false }
}
