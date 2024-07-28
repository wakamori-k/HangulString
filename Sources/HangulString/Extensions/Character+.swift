//
//  Character+.swift
//
//
//  Created by 若森和昌 on 2022/03/30.
//

extension Character {

    /// A Boolean value indicating whether this character is a hangul letter represented in hangul syllables.
    var isHangulSyllable: Bool {

        guard unicodeScalars.count == 1 else {
            return false
        }

        guard let first = unicodeScalars.first,
              first.isHangulSyllable() else {
            return false
        }

        return true
    }

    /// A Boolean value indicating whether this character is a hangul letter represented in hangul jamos.
    var isHangulJamos: Bool {

        let scalars = unicodeScalars.map { $0 }

        if scalars.count == 2 &&
            scalars[0].isHangulJamoInitialConsonant() &&
            scalars[1].isHangulJamoVowel() {
            return true
        }

        if scalars.count == 3 &&
            scalars[0].isHangulJamoInitialConsonant() &&
            scalars[1].isHangulJamoVowel() &&
            scalars[2].isHangulJamoFinalConsonant() {
            return true
        }

        return false
    }

    /// Convert the character to hangul jamo representation.
    ///
    /// Examples of representations as hangul jamo .
    /// ```
    /// '아' = 'ㅇ' + 'ㅏ'
    /// '안' = 'ㅇ' + 'ㅏ' + 'ㄴ'
    /// ```
    func toHangulJamos() -> Character? {
        if self.isHangulJamos {
            return self
        }

        guard self.isHangulSyllable else {
            return nil
        }

        guard let first = self.unicodeScalars.first else {
            return nil
        }

        let code = first.value - Unicode.Scalar.hangulSyllableOffset.value
        let onset = (code - code % 28) / 28 / 21 + 0x1100
        let nucleus = (code - code % 28) / 28 % 21 + 0x1161
        var jamoScalars: [Unicode.Scalar] = [Unicode.Scalar(onset)!, Unicode.Scalar(nucleus)!]
        if code % 28 > 0 {
            let coda: UInt32 = code % 28 + 0x11A7
            jamoScalars.append(Unicode.Scalar(coda)!)
        }

        let jamoString = jamoScalars.map { String($0) }.reduce("", +)
        return Character(jamoString)
    }

    /// Convert the character to hangul syllable representation.
    func toHangulSyllable() -> Character? {
        if self.isHangulSyllable {
            return self
        }

        guard self.isHangulJamos else {
            return nil
        }

        var syllableValue: UInt32 = 0xAC00 // offset
        guard let scalars = self.toHangulJamos()?.unicodeScalars else {
            return nil
        }

        let choseong = scalars.first!.value
        syllableValue += (choseong - 0x1100) * 588

        let jungseong = scalars[scalars.index(scalars.startIndex, offsetBy: 1)].value
        syllableValue += (jungseong - 0x1161) * 28

        if self.unicodeScalars.count > 2 {
            let jongseong = scalars[scalars.index(scalars.startIndex, offsetBy: 2)].value
            syllableValue += (jongseong - 0x11A7)
        }

        guard let syllableScalar = Unicode.Scalar(syllableValue) else {
            return nil
        }
        return Character(syllableScalar)
    }

    /// Romanized given hangul character by following the Revised Romanization of Korean rule.
    /// https://www.korean.go.kr/front_eng/roman/roman_01.do
    ///
    /// If the character is not hangul, returns the character casted to String.
    func romanized() -> String {

        guard let jamos = toHangulJamos() else {
            return String(self)
        }

        return jamos.unicodeScalars.map { $0 }.hangulRomanized
    }

}
