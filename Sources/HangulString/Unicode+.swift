//
//  Constants.swift
//  
//
//  Created by 若森和昌 on 2022/03/31.
//

extension Unicode.Scalar {
    
    static let hangylSyllableStart: Self = Unicode.Scalar(UInt32(0xAC00))!
    static let hangylSyllableEnd: Self = Unicode.Scalar(UInt32(0xD7AF))!
    static let hangulSyllableRange = hangylSyllableStart...hangylSyllableEnd
    
    /// Convert to romans by "Revised Romanization of Korean".
    ///
    /// https://www.korean.go.kr/front_eng/roman/roman_01.do
    /// https://en.wikipedia.org/wiki/Revised_Romanization_of_Korean
    var hangulRomanized: String? {
        
        if 0x1100 <= value && value <= 0x1112 {
            // 초성(choseong)
            return Romanization.choseong[Int(value) - 0x1100]
            
        } else if 0x1161 <= value && value <= 0x1175 {
            // 중성 (jungseong)
            return Romanization.jungseong[Int(value) - 0x1161]
            
        } else if 0x11A8 <= value && value <= 0x11C2 {
            // 종성 (jongseong)
            return Romanization.jongseong[Int(value) - 0x11A8]
            
        }
        
        return nil
    }
}

private extension Unicode.Scalar {
    
    struct Romanization {
        
        /// Romanizations of initial consonants in hangul.
        static let choseong: [String] = [
            "g", // ᄀ
            "kk", // ᄁ
            "n", // ᄂ
            "d", // ᄃ
            "tt", // ᄄ
            "r", // ᄅ
            "m", // ᄆ
            "b", // ᄇ
            "pp", // ᄈ
            "s", // ᄉ
            "ss", // ᄊ
            "", // ᄋ
            "j", // ᄌ
            "jj", // ᄍ
            "ch", // ᄎ
            "k", // ᄏ
            "t", // ᄐ
            "p", // ᄑ
            "h", // ᄒ
        ]
        
        /// Romanizations of medial vowels in hangul.
        static let jungseong: [String] = [
            "a", // ᅡ
            "ae", // ᅢ
            "ya", // ᅣ
            "yae", // ᅤ
            "eo", // ᅥ
            "e", // ᅦ
            "yeo", // ᅧ
            "ye", // ᅨ
            "o", // ᅩ
            "wa", // ᅪ
            "wae", // ᅫ
            "oe", // ᅬ
            "yo", // ᅭ
            "u", // ᅮ
            "wo", // ᅯ
            "we", // ᅰ
            "wi", // ᅱ
            "yu", // ᅲ
            "eu", // ᅳ
            "ui", // ᅴ
            "i", // ᅵ
        ]
        
        /// Romanizations of final consonants in hangul.
        static let jongseong: [String] = [
            "g", "k", "gs", "n",
            "nj", "nh", "t", "l", "lg",
            "lm", "lb", "ls", "lt", "lp",
            "lh", "m", "b", "bs", "s",
            "ss", "ng", "j", "ch", "k",
            "t", "p", "h"
        ]
        
    }
}

