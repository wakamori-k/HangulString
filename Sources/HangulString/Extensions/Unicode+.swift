//
//  Constants.swift
//
//
//  Created by 若森和昌 on 2022/03/31.
//

extension [Unicode.Scalar] {

    /// Convert to romans by "Revised Romanization of Korean".
    ///
    /// https://www.korean.go.kr/front_eng/roman/roman_01.do
    /// https://en.wikipedia.org/wiki/Revised_Romanization_of_Korean
    /// https://www.tufs.ac.jp/ts/personal/choes/korean/nanboku/Romajaj.html
    ///
    var hangulRomanized: String {
        var romanized = ""

        for i in 0..<count {
            romanized += romanize(
                scalar: self[i],
                next: (i + 1 < count) ? self[i+1] : nil) ?? ""
        }

        return romanized
    }

    private func romanize(scalar: Unicode.Scalar, next: Unicode.Scalar?) -> String? {
        let value = Int(scalar.value)

        if 0x1100 <= value && value <= 0x1112 {
            // 초성(choseong)
            return Unicode.Scalar.Romanization.choseong[value - 0x1100]

        } else if 0x1161 <= value && value <= 0x1175 {
            // 중성 (jungseong)
            return Unicode.Scalar.Romanization.jungseong[value - 0x1161]

        } else if 0x11A8 <= value && value <= 0x11C2 {
            // 종성 (jongseong)
            return Unicode.Scalar.Romanization.jongseong[value - 0x11A8]

        }

        return nil
    }
}

extension Unicode.Scalar {
    static let hangulSyllableOffset: Self = Unicode.Scalar(UInt32(0xAC00))!

    /// A Boolean value indicating whether this unicode scalar is any hangul syllables.
    func isHangulSyllable() -> Bool {
        let range = Self.hangulSyllableOffset.value...UInt32(0xD7A3)
        return range.contains(self.value)
    }

    /// A Boolean value indicating whether this unicode scalar is any initial consonant jamos.
    /// For the jamo representation in Unicode, see also: https://www.unicode.org/charts/PDF/U1100.pdf
    /// - Returns: `true` if the scalar value is any initial consonants, otherwise `false`.
    func isHangulJamoInitialConsonant() -> Bool {
        let range = UInt32(0x1100)...UInt32(0x1112)
        return range.contains(self.value)
    }

    /// A Boolean value indicating whether this unicode scalar is any vowel jamos.
    /// For the jamo representation in Unicode, see also: https://www.unicode.org/charts/PDF/U1100.pdf
    /// - Returns: `true` if the scalar value is any vowels, otherwise `false`.
    func isHangulJamoVowel() -> Bool {
        let range = UInt32(0x1161)...UInt32(0x1175)
        return range.contains(self.value)
    }

    /// A Boolean value indicating whether this unicode scalar is any final consonant jamos.
    /// For the jamo representation in Unicode, see also: https://www.unicode.org/charts/PDF/U1100.pdf
    /// - Returns: `true` if the scalar value is any final consonants, otherwise `false`.
    func isHangulJamoFinalConsonant() -> Bool {
        let range = UInt32(0x11A8)...UInt32(0x11C2)
        return range.contains(self.value)
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
            "h" // ᄒ
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
            "i" // ᅵ
        ]

        /// Romanizations of final consonants in hangul.
        static let jongseong: [String] = [
            "k", // ᆨ
            "kk", // ᆩ
            "ks", // ᆪ
            "n", // ᆫ
            "nj", // ᆬ
            "nh", // ᆭ
            "t", // ᆮ
            "l", // ᆯ
            "lk", // ᆰ
            "lm", // ᆱ
            "lp", // ᆲ
            "ls", // ᆳ
            "lt", // ᆴ
            "lp", // ᆵ
            "lh", // ᆶ
            "m", // ᆷ
            "p", // ᆸ
            "ps", // ᆹ
            "s", // ᆺ
            "ss", // ᆻ
            "ng", // ᆼ
            "j", // ᆽ
            "ch", // ᆾ
            "k", // ᆿ
            "t", // ᇀ
            "p", // ᇁ
            "h" // ᇂ
        ]

    }
}
