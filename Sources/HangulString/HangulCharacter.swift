//
//  HangulCharacter.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/05.
//

public struct HangulCharacter {
    private let syllable: Character
    private let jamoScalars: [UnicodeHangulJamoScalar]

    /// Creates a new hangul character containing the given character.
    ///
    /// The specified character must be a hangle character, otherwise this initializer throw an error.
    ///
    /// - Parameter character: A character instance
    public init(_ character: Character) throws {

        guard let scalars = character.toHangulJamos()?.unicodeScalars else {
            throw HangulStringError.invalidCharacter
        }

        var jamoScalars: [UnicodeHangulJamoScalar] = []
        for s in scalars {
            do {
                jamoScalars.append(try UnicodeHangulJamoScalar(s))
            } catch {
                throw HangulStringError.invalidCharacter
            }
        }

        self.jamoScalars = jamoScalars
        self.syllable = character.toHangulSyllable()!
    }

    init(_ character: HangulCharacterInJamos) throws {
        let unicodeScalars = character.toJamoScalars().map { UnicodeScalar($0.value)! }
        try self.init(Character(String(String.UnicodeScalarView(unicodeScalars))))
    }

    /// Hangul character represented in hangul syllables.
    public func toSyllableCharacter() -> Character {
        return syllable
    }

    /// Hangul character represented in hangul jamos.
    ///
    /// Examples of representations as hangul jamo .
    /// ```
    /// '아' = 'ㅇ' + 'ㅏ'
    /// '안' = 'ㅇ' + 'ㅏ' + 'ㄴ'
    /// ```
    public func toJamoCharacter() -> Character {
        return syllable.toHangulJamos()!
    }

    func toJamos() -> HangulCharacterInJamos {
        guard let vowelIndex = (jamoScalars.firstIndex { $0.isHangulJamoVowel() }) else {
            fatalError("Unreachable.")
        }
        guard let initialConsonant =
                (Array(jamoScalars[0..<vowelIndex].flatMap { $0.toJamos()}) as? [ConsonantJamo]) else {
            fatalError("Unreachable.")
        }
        guard let vowel = jamoScalars[vowelIndex].toJamos().first as? VowelJamo else {
            fatalError("Unreachable.")
        }
        var finalConsonant: [ConsonantJamo] = []
        if let fc = (Array(jamoScalars[vowelIndex+1..<jamoScalars.count].flatMap { $0.toJamos()}) as? [ConsonantJamo]) {
            finalConsonant = fc
        }

        return HangulCharacterInJamos(initialConsonant: initialConsonant,
                                      vowel: vowel,
                                      finalConsonant: finalConsonant)
    }

    /// Romanized given hangul character by following the Revised Romanization of Korean rule.
    /// https://www.korean.go.kr/front_eng/roman/roman_01.do
    ///
    /// If the character is not hangul, returns the character casted to String.
    public func romanized() -> String {
        return syllable.romanized()
    }

    /// Katakanize this hangul character.
    public func katakanize(vocalize: Bool) -> String {
        return self.toJamos().katakanize(vocalize: vocalize)
    }

    /// Returns a boolean value whether the character starts with a vowel.
    ///
    /// - Returns: `true` if the initial consonant is ieung (`ㅇ`), otherwize `false`
    public func startsWithVowel() -> Bool {
        return toJamos().initialConsonant == [.ieung]
    }
}

extension HangulCharacter: Equatable {
    public static func == (lhs: HangulCharacter, rhs: HangulCharacter) -> Bool {
        return lhs.syllable == rhs.syllable
    }
}
