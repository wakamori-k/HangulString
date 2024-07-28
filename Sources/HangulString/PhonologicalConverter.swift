//
//  PhonologicalConverter.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/05.
//

import Foundation

/// Phonological conversion in Korean.
///
/// Refernces:
/// - https://www.missellykorean.com/korean-sound-change-rules-pdf/
/// - https://trilingual.jp/jako/20200207-4203/
/// - https://fluentinkorean.com/korean-hangul-pronunciation/
/// - https://nativecamp.net/blog/20190613_hangul
protocol PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString
}

/// Carry  ending consonants over each following character if the corresponding following character starts with a vowel.
///
/// E.g. `옷을` -> `오슬`, `앉아` -> `안자`, `있어요` -> `이써요`.
///
/// Exception1: If the character ends with the consonant ieung `ㅇ`,
/// it is not carried over. E.g. `생일` is not changed.
/// Exception2: If the character ends with the consonant hieut  `ㅎ`,
/// the consonant is ignored. E.g. `좋아` -> `조아`, `싫어` -> `시러`.
struct ResyllabificationConverter: PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString {
        guard hangulString.count > 1 else {
            return hangulString
        }
        var converted = hangulString

        for i in 0..<converted.count - 1 {
            let resyllabified = try resyllabify(currentChar: converted[i], nextChar: converted[i+1])
            converted[i] = resyllabified.0
            converted[i+1] = resyllabified.1
        }

        return converted
    }

    /// Resyllabify if the `currentChar` has a final consonant and the `nextChar` does not start with a vowel.
    ///
    /// Exception1: If the `currentChar` ends with the consonant ieung `ㅇ`, it does not carry over.
    /// Exception2: If the `currentChar` ends with the consonant hieut  `ㅎ`, the consonant is ignored.
    /// - Parameters:
    ///   - currentChar: Hangul character before `nextChar`
    ///   - nextChar: Hangul character followed by `currentChar`
    /// - Returns: Tuple of resyllabified characters
    private static func resyllabify(currentChar: HangulCharacter,
                                    nextChar: HangulCharacter) throws -> (HangulCharacter, HangulCharacter) {
        let currentJamos = currentChar.toJamos()
        let nextJamos = nextChar.toJamos()
        var currentChar = currentChar
        var currentFinalConsonant = currentJamos.finalConsonant
        if let last = currentFinalConsonant.last, last == .hieut {
            currentFinalConsonant.removeLast()
            let currentCharJamos = currentChar.toJamos()
            currentChar = try HangulCharacter(
                HangulCharacterInJamos(initialConsonant: currentCharJamos.initialConsonant,
                                       vowel: currentCharJamos.vowel,
                                       finalConsonant: currentFinalConsonant)
            )
        }

        guard currentFinalConsonant.count > 0 else {
            // no final consonant in current character
            return (currentChar, nextChar)
        }
        guard currentFinalConsonant != [.ieung] else {
            // final consonant in ieung
            return (currentChar, nextChar)
        }
        guard nextChar.startsWithVowel() else {
            // next character does not start with vowel.
            return (currentChar, nextChar)
        }

        var resyllabifiedCurrentFinalConsonant: [ConsonantJamo] = []
        var resyllabifiedNextInitialConsonant: [ConsonantJamo] = currentFinalConsonant
        // Check if currentFinalConsonant having multiple consonants can be first consonant
        if currentFinalConsonant.count > 1
            && !isGeminateConsonant(jamos: (currentFinalConsonant[0], currentFinalConsonant[1])) {
            // If not, split the two consonants are used in current and next, respectevely.
            resyllabifiedCurrentFinalConsonant = [currentFinalConsonant[0]]
            resyllabifiedNextInitialConsonant = [currentFinalConsonant[1]]
        }

        let resyllabifiedCurrent = HangulCharacterInJamos(initialConsonant: currentJamos.initialConsonant,
                                                          vowel: currentJamos.vowel,
                                                          finalConsonant: resyllabifiedCurrentFinalConsonant)
        let resyllabifiedNext = HangulCharacterInJamos(initialConsonant: resyllabifiedNextInitialConsonant,
                                                       vowel: nextJamos.vowel,
                                                       finalConsonant: nextJamos.finalConsonant)

        return (try HangulCharacter(resyllabifiedCurrent), try HangulCharacter(resyllabifiedNext))
    }

    /// Determine whether the jamos is geminae consonant (double consonant).
    /// - Parameter jamos: A pair of consonant jamos
    /// - Returns: `true` if jamos is geminate consonant, otherwise `false`.
    private static func isGeminateConsonant(jamos: (ConsonantJamo, ConsonantJamo)) -> Bool {
        switch jamos {
        case (.giyeok, .giyeok),
             (.digeut, .digeut),
             (.bieup, .bieup),
             (.siot, .siot),
             (.chieut, .chieut):
            return true
        default:
            return false
        }
    }
}

/// Reinforce initial consonants followed by a character that has a final consonant pronounced as `ㄱ`, `ㄷ`, or `ㅂ`.
///
/// Reinforcing means converting any target consonants (`ㄱ`, `ㄷ`,` ㅂ`, `ㅅ`, or`ㅈ`)
/// to the corresponding double consonant, e.g. `ㄱ` -> `ㄲ`.
///
/// Note that, `ㄷ`, `ㅌ`, `ㅅ`, `ㅆ`, `ㅈ`, `ㅊ`, and `ㅎ` are recognized to be pronounced as `ㄷ`,
/// and `ㅍ` is recognized to be pronounced as `ㅂ`. So, an initial consonant followed
/// by such consonants is reinforced by this converter.
///
/// Exception: An ending `ㅎ` only reinforces `ㅅ` to `ㅆ`.
struct ReinforcementConverter: PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString {
        guard hangulString.count > 1 else {
            return hangulString
        }
        var converted = hangulString

        for i in 0..<converted.count - 1 {
            let resyllabified = try reinforce(currentChar: converted[i], nextChar: converted[i+1])
            converted[i] = resyllabified.0
            converted[i+1] = resyllabified.1
        }
        return converted
    }

    private static func reinforce(currentChar: HangulCharacter,
                                  nextChar: HangulCharacter) throws -> (HangulCharacter, HangulCharacter) {

        let jamos = currentChar.toJamos()

        var intensified = (currentChar, nextChar)
        if jamos.finalConsonant == [.siot, .siot] || jamos.finalConsonant == [.giyeok, .giyeok] {
            intensified.1 = try reinforce(character: intensified.1)
        } else if let lastConsonant = jamos.finalConsonant.last {
            switch lastConsonant {
            case .giyeok,
                 .digeut,
                 .tieut,
                 .siot,
                 .chieut,
                 .jieut,
                 .bieup,
                 .pieup:
                intensified.1 = try reinforce(character: intensified.1)
            case .hieut:
                if intensified.1.toJamos().initialConsonant == [.siot] {
                    intensified.1 = try reinforce(character: intensified.1)
                }
            default:
                break
            }
        }

        return intensified
    }

    /// Intensify the first consonant of the character.
    ///
    /// Strengthen the first consonant to its double consonant equivalent, if it has one.
    private static func reinforce(character: HangulCharacter) throws -> HangulCharacter {
        let jamos = character.toJamos()
        guard jamos.initialConsonant == [.bieup] ||
                jamos.initialConsonant == [.jieut] ||
                jamos.initialConsonant == [.digeut] ||
                jamos.initialConsonant == [.giyeok] ||
                jamos.initialConsonant == [.bieup] ||
                jamos.initialConsonant == [.siot]
        else {
            return character
        }

        return try HangulCharacter(
            HangulCharacterInJamos(
                initialConsonant: [jamos.initialConsonant[0], jamos.initialConsonant[0]],
                vowel: jamos.vowel,
                finalConsonant: jamos.finalConsonant))
    }
}

/// Simplify target final consonants if the next character does not start with vowel.
///
/// This function simplify each final consonant according to the following rules.
/// - `ㅋ` is simplified as `ㄱ`.
/// - `ㅌ` is simplified as `ㄷ`.
/// - `ㅍ` is simplified as `ㅂ`.
/// - `ㄲ` is simplified as `ㄱ`.
/// - `ㅅ`, `ㅆ`, `ㅈ`, `ㅊ`, and `ㅎ` are simplified as `ㄷ`.
struct EndingConsonantSimplificationConverter: PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString {
        var converted = hangulString
        for i in 0..<converted.count {
            let nextCharacter = i < converted.count - 1 ? converted[i+1] : nil
            converted[i] = try simplify(character: converted[i], nextCharacter: nextCharacter)
        }

        return converted
    }

    /// Simplify the ending consonant of the character
    ///
    /// if needed. If the character ends with any aspirated consonant or any double consonant,
    /// the final consonant is simplified.
    ///
    /// Exception: when the next character starts with vowel, the character is not simplified in any way.
    /// - Parameters:
    ///   - character: Character to simplify
    ///   - nextCharacter: The next character of `character` if exists
    /// - Returns: Character simplified as needed
    private static func simplify(character: HangulCharacter,
                                 nextCharacter: HangulCharacter?) throws -> HangulCharacter {
        if let nextCharacter = nextCharacter, nextCharacter.toJamos().initialConsonant[0] == .ieung {
            return character
        }

        let jamos = character.toJamos()
        guard jamos.finalConsonant.count > 0 else {
            return character
        }

        let map: [[ConsonantJamo]: [ConsonantJamo]] = [
            [.kieuk]: [.giyeok],
            [.tieut]: [.digeut],
            [.pieup]: [.bieup],
            [.siot]: [.digeut],
            [.siot, .siot]: [.digeut],
            [.chieut]: [.digeut],
            [.jieut]: [.digeut],
            [.giyeok, .giyeok]: [.giyeok]
        ]
        let simplifiedFinalConsonant = map[jamos.finalConsonant] ?? jamos.finalConsonant

        return try HangulCharacter(HangulCharacterInJamos(initialConsonant: jamos.initialConsonant,
                                                          vowel: jamos.vowel,
                                                          finalConsonant: simplifiedFinalConsonant)
        )
    }

}

/// Nasalise final consonants if the following character starts with `ㅁ` or `ㄴ`.
///
/// A final consonant `ㄱ` and `ㄹ` + `ㄱ` is nasalised as `ㅇ`.
/// A final consonant `ㄷ`, `ㅅ`, `ㅈ`, and `ㅊ` are nasalised as `ㄴ`.
/// A final consonant `ㅂ` is nasalised as `ㅁ`.
///
/// Each following character is not modified except when the initial consonant `ㄹ`is  followed by ending with `ㄱ`,
/// the `ㄱ` becomes `ㅇ` and `ㄹ` becomes `ㄴ`.
struct NasalisationConverter: PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString {
        guard hangulString.count > 1 else {
            return hangulString
        }
        var converted = hangulString
        for i in 0..<converted.count - 1 {
            let nasalised = try nasalise(character: converted[i], nextCharacter: converted[i+1])
            converted[i] = nasalised.0
            converted[i+1] = nasalised.1
        }

        return converted
    }

    private static func nasalise(character: HangulCharacter,
                                 nextCharacter: HangulCharacter) throws -> (HangulCharacter, HangulCharacter) {
        let jamos = character.toJamos()
        let nextJamos = nextCharacter.toJamos()
        guard nextJamos.initialConsonant != [.rieul] else {
            var nasalisedFinalConsonant = jamos.finalConsonant
            var nasalisedNextInitialConsonant = nextJamos.initialConsonant
            if jamos.finalConsonant == [.giyeok] {
                // exception
                nasalisedFinalConsonant = [.ieung]
                nasalisedNextInitialConsonant = [.nieun]
            }
            let nasalisedCharacter = try HangulCharacter(
                HangulCharacterInJamos(initialConsonant: jamos.initialConsonant,
                                       vowel: jamos.vowel,
                                       finalConsonant: nasalisedFinalConsonant))
            let nasalisedNextCharacter = try HangulCharacter(
                HangulCharacterInJamos(initialConsonant: nasalisedNextInitialConsonant,
                                       vowel: nextJamos.vowel,
                                       finalConsonant: nextJamos.finalConsonant))
            return (nasalisedCharacter, nasalisedNextCharacter)
        }
        guard nextJamos.initialConsonant == [.mieum] || nextJamos.initialConsonant == [.nieun] else {
            return (character, nextCharacter)
        }

        var nasalisedFinalConsonant = jamos.finalConsonant
        switch jamos.finalConsonant {
        case [.giyeok], [.rieul, .giyeok]:
            nasalisedFinalConsonant = [.ieung]
        case [.digeut], [.siot], [.jieut], [.chieut]:
            nasalisedFinalConsonant = [.nieun]
        case [.bieup]:
            nasalisedFinalConsonant = [.mieum]
        default:
            break
        }
        let nasalisedCharacter = try HangulCharacter(
            HangulCharacterInJamos(initialConsonant: jamos.initialConsonant,
                                   vowel: jamos.vowel,
                                   finalConsonant: nasalisedFinalConsonant))
        return (nasalisedCharacter, nextCharacter)
    }

}

/// Assimilate both a final consonant and the following initial consonant into `ㄴ`
/// when the final consonant and the initial consonant are`ㄴ` and `ㄹ`, or vice versa.
struct AssimilationConverter: PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString {
        guard hangulString.count > 1 else {
            return hangulString
        }
        var converted = hangulString
        for i in 0..<converted.count - 1 {
            let assimilated = try assimilate(character: converted[i], nextCharacter: converted[i+1])
            converted[i] = assimilated.0
            converted[i+1] = assimilated.1
        }

        return converted
    }

    private static func assimilate(character: HangulCharacter,
                                   nextCharacter: HangulCharacter) throws -> (HangulCharacter, HangulCharacter) {
        let jamos = character.toJamos()
        let nextJamos = nextCharacter.toJamos()

        guard (jamos.finalConsonant == [.rieul] && nextJamos.initialConsonant == [.nieun]) ||
                (jamos.finalConsonant == [.nieun] && nextJamos.initialConsonant == [.rieul]) else {
            return (character, nextCharacter)
        }

        let resyllabifiedCurrent = HangulCharacterInJamos(initialConsonant: jamos.initialConsonant,
                                                          vowel: jamos.vowel,
                                                          finalConsonant: [.rieul])
        let resyllabifiedNext = HangulCharacterInJamos(initialConsonant: [.rieul],
                                                       vowel: nextJamos.vowel,
                                                       finalConsonant: nextJamos.finalConsonant)

        return (try HangulCharacter(resyllabifiedCurrent), try HangulCharacter(resyllabifiedNext))
    }
}

/// Aspirate stop sound consonants followed by or following  a `ㅎ` and remove the `ㅎ`.
///
/// E.g. `축하해` -> `추카해`, `많다` -> `만타`.
struct AspirationConverter: PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString {
        guard hangulString.count > 1 else {
            return hangulString
        }
        var converted = hangulString
        for i in 0..<converted.count - 1 {
            let aspirated = try aspiration(character: converted[i], nextCharacter: converted[i+1])
            converted[i] = aspirated.0
            converted[i+1] = aspirated.1
        }

        return converted
    }

    private static func aspiration(character: HangulCharacter,
                                   nextCharacter: HangulCharacter) throws -> (HangulCharacter, HangulCharacter) {
        let jamos = character.toJamos()
        let nextJamos = nextCharacter.toJamos()

        guard jamos.finalConsonant.last == .hieut || nextJamos.initialConsonant.first == .hieut else {
            return (character, nextCharacter)
        }

        var aspiratedFinalConsonant = jamos.finalConsonant
        var aspiratedNextInitialConsonant = nextJamos.initialConsonant

        // mapping from stop sounds to corresponding strengthened sound.
        let map: [ConsonantJamo?: ConsonantJamo] = [
            .giyeok: .kieuk,
            .digeut: .tieut,
            .bieup: .pieup,
            .jieut: .chieut
        ]

        if aspiratedFinalConsonant.last == .hieut, let mapped = map[aspiratedNextInitialConsonant.first] {
            aspiratedFinalConsonant.removeLast()
            aspiratedNextInitialConsonant = [mapped]
        } else if aspiratedNextInitialConsonant.first == .hieut, let mapped = map[aspiratedFinalConsonant.last] {
            aspiratedFinalConsonant.removeLast()
            aspiratedNextInitialConsonant = [mapped]
        }

        let aspiratedCurrent = HangulCharacterInJamos(initialConsonant: jamos.initialConsonant,
                                                      vowel: jamos.vowel,
                                                      finalConsonant: aspiratedFinalConsonant)
        let aspiratedNext = HangulCharacterInJamos(initialConsonant: aspiratedNextInitialConsonant,
                                                   vowel: nextJamos.vowel,
                                                   finalConsonant: nextJamos.finalConsonant)

        return (try HangulCharacter(aspiratedCurrent), try HangulCharacter(aspiratedNext))
    }
}

/// Palatalise `ㄷ` or `ㅌ` .
///
/// When `ㄷ` or `ㅌ` is followed by `이`, it is converted to `ㅈ` or `ㅊ`, respectively.
/// When `ㄷ` is folloed by `히`, `ㄷ` is converted to `ㅊ`.
/// Each converted consonant is moved to the next character and replace
/// with the initial consonant in the next character.
///
/// E.g. `굳이` -> `구지`, `같이` -> `가치`, `묻히다` -> `무치다`.
struct PalatalisationConverter: PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString {
        guard hangulString.count > 1 else {
            return hangulString
        }
        var converted = hangulString
        for i in 0..<converted.count - 1 {
            var palatalised = try palataliseI(character: converted[i], nextCharacter: converted[i+1])
            palatalised = try palataliseHi(character: palatalised.0, nextCharacter: palatalised.1)
            converted[i] = palatalised.0
            converted[i+1] = palatalised.1
        }

        return converted
    }

    private static func palataliseI(character: HangulCharacter,
                                    nextCharacter: HangulCharacter) throws -> (HangulCharacter, HangulCharacter) {
        let jamos = character.toJamos()
        let nextJamos = nextCharacter.toJamos()

        guard nextJamos.initialConsonant == [.ieung] && nextJamos.vowel == .i else {
            return (character, nextCharacter)
        }

        var aspiratedFinalConsonant = jamos.finalConsonant
        var aspiratedNextInitialConsonant = nextJamos.initialConsonant

        let map: [ConsonantJamo?: ConsonantJamo] = [
            .digeut: .jieut,
            .tieut: .chieut
        ]

        if let mapped = map[aspiratedFinalConsonant.last] {
            aspiratedFinalConsonant.removeLast()
            aspiratedNextInitialConsonant = [mapped]
        }

        let aspiratedCurrent = HangulCharacterInJamos(initialConsonant: jamos.initialConsonant,
                                                      vowel: jamos.vowel,
                                                      finalConsonant: aspiratedFinalConsonant)
        let aspiratedNext = HangulCharacterInJamos(initialConsonant: aspiratedNextInitialConsonant,
                                                   vowel: nextJamos.vowel,
                                                   finalConsonant: nextJamos.finalConsonant)

        return (try HangulCharacter(aspiratedCurrent), try HangulCharacter(aspiratedNext))
    }
    private static func palataliseHi(character: HangulCharacter,
                                     nextCharacter: HangulCharacter) throws -> (HangulCharacter, HangulCharacter) {
        let jamos = character.toJamos()
        let nextJamos = nextCharacter.toJamos()

        guard nextJamos.initialConsonant == [.hieut] && nextJamos.vowel == .i else {
            return (character, nextCharacter)
        }

        var aspiratedFinalConsonant = jamos.finalConsonant
        var aspiratedNextInitialConsonant = nextJamos.initialConsonant

        let map: [ConsonantJamo?: ConsonantJamo] = [
            .digeut: .chieut
        ]

        if let mapped = map[aspiratedFinalConsonant.last] {
            aspiratedFinalConsonant.removeLast()
            aspiratedNextInitialConsonant = [mapped]
        }

        let aspiratedCurrent = HangulCharacterInJamos(initialConsonant: jamos.initialConsonant,
                                                      vowel: jamos.vowel,
                                                      finalConsonant: aspiratedFinalConsonant)
        let aspiratedNext = HangulCharacterInJamos(initialConsonant: aspiratedNextInitialConsonant,
                                                   vowel: nextJamos.vowel,
                                                   finalConsonant: nextJamos.finalConsonant)

        return (try HangulCharacter(aspiratedCurrent), try HangulCharacter(aspiratedNext))
    }
}

/// A converter that transforms a Hangul string into its phonological representation by handling the "Hieut" consonant.
///
/// This structure provides methods to convert a Hangul string by applying specific rules to handle the "Hieut" consonant
/// when it appears in specific contexts.
struct SilenationHieutConverter: PhonologicalConverter {
    static func convert(hangulString: HangulString) throws -> HangulString {
        guard hangulString.count > 1 else {
            return hangulString
        }
        var converted = hangulString
        for i in 0..<converted.count - 1 {
            var palatalised = try silence(character: converted[i], nextCharacter: converted[i+1])
            palatalised = try silence(character: palatalised.0, nextCharacter: palatalised.1)
            converted[i] = palatalised.0
            converted[i+1] = palatalised.1
        }

        return converted
    }
    private static func silence(character: HangulCharacter,
                                nextCharacter: HangulCharacter) throws -> (HangulCharacter, HangulCharacter) {
        let jamos = character.toJamos()
        let nextJamos = nextCharacter.toJamos()
        guard nextJamos.initialConsonant == [.hieut] else {
            return (character, nextCharacter)
        }

        guard jamos.finalConsonant.count == 1 && Set<ConsonantJamo>([.nieun, .rieul, .mieum]).contains(jamos.finalConsonant[0]) else {
            return (character, nextCharacter)
        }

        let aspiratedCurrent = HangulCharacterInJamos(initialConsonant: jamos.initialConsonant,
                                                      vowel: jamos.vowel,
                                                      finalConsonant: [])
        let aspiratedNext = HangulCharacterInJamos(initialConsonant: jamos.finalConsonant,
                                                   vowel: nextJamos.vowel,
                                                   finalConsonant: nextJamos.finalConsonant)

        return (try HangulCharacter(aspiratedCurrent), try HangulCharacter(aspiratedNext))
    }
}
