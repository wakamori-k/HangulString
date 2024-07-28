//
//  UnicodeHangulJamoScalar.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/06.
//

enum UnicodeHangulJamoGroup {
    case initialConsonant
    case vowel
    case finalConsonant
}

struct UnicodeHangulJamoScalar {
    private let scalar: UnicodeScalar
    var value: UInt32 {
        scalar.value
    }

    /// Creates a new hangul jamo unicode scalar.
    /// - Parameter string: A unicode scalar
    init(_ scalar: Unicode.Scalar) throws {
        guard scalar.isHangulJamoInitialConsonant() ||
                scalar.isHangulJamoVowel() ||
                scalar.isHangulJamoFinalConsonant() else {
            throw HangulStringError.invalidUnicodeScalar
        }

        self.scalar = scalar
    }

    init(jamos: [VowelJamo]) {
        guard let value = Self.jamosToVowelScalarValue[jamos], let scalar = Unicode.Scalar(value) else {
            fatalError("Unreachable.")
        }
        self.scalar = scalar
    }

    init(jamos: [ConsonantJamo], firstConsonant: Bool) throws {
        var value: UInt32?

        if firstConsonant {
            value = Self.jamosToInitialConsonantScalarValue[jamos]
        } else {
            value = Self.jamosToFinalConsonantScalarValue[jamos]
        }
        guard let value = value else {
            throw HangulStringError.invalidJamoSequence
        }
        guard let scalar = Unicode.Scalar(value) else {
            fatalError("Unreachable.")
        }
        self.scalar = scalar
    }

    /// Converts to an array of ``Jamo``
    /// - Returns: Array of ``Jamo``
    func toJamos() -> [Jamo] {
        return Self.scalarValueToJamos[self.scalar.value]!
    }

    /// A Boolean value indicating whether this unicode scalar is any initial consonant jamos.
    /// For the jamo representation in Unicode, see also: https://www.unicode.org/charts/PDF/U1100.pdf
    /// - Returns: `true` if the scalar value is any initial consonants, otherwise `false`.
    func isHangulJamoInitialConsonant() -> Bool {
        return scalar.isHangulJamoInitialConsonant()
    }

    /// A Boolean value indicating whether this unicode scalar is any vowel jamos.
    /// For the jamo representation in Unicode, see also: https://www.unicode.org/charts/PDF/U1100.pdf
    /// - Returns: `true` if the scalar value is any vowels, otherwise `false`.
    func isHangulJamoVowel() -> Bool {
        return scalar.isHangulJamoVowel()
    }

    /// A Boolean value indicating whether this unicode scalar is any final consonant jamos.
    /// For the jamo representation in Unicode, see also: https://www.unicode.org/charts/PDF/U1100.pdf
    /// - Returns: `true` if the scalar value is any final consonants, otherwise `false`.
    func isHangulJamoFinalConsonant() -> Bool {
        return scalar.isHangulJamoFinalConsonant()
    }
}

extension UnicodeHangulJamoScalar: Equatable {
    static func == (lhs: UnicodeHangulJamoScalar, rhs: UnicodeHangulJamoScalar) -> Bool {
        return lhs.scalar == rhs.scalar
    }
}

private extension UnicodeHangulJamoScalar {

    /// Dictionary to map Hangul Jamo unicode value to an array of ``Jamo``.
    static private let scalarValueToJamos: [UInt32: [Jamo]] = {
        var dict: [UInt32: [Jamo]] = Dictionary(
            uniqueKeysWithValues: Self.jamosToInitialConsonantScalarValue.map { ($0.value, $0.key) })
        let vowelDict: [UInt32: [Jamo]] = Dictionary(
            uniqueKeysWithValues: Self.jamosToVowelScalarValue.map { ($0.value, $0.key) })
        let finalConsonantDict: [UInt32: [Jamo]] = Dictionary(
            uniqueKeysWithValues: Self.jamosToFinalConsonantScalarValue.map { ($0.value, $0.key) })

        dict.merge(vowelDict) { (_, _) in preconditionFailure("Keys should not be duplicated.") }
        dict.merge(finalConsonantDict) { (_, _) in preconditionFailure("Keys should not be duplicated.") }

        return dict
    }()

    /// Dictionary to map an array of ``Jamo`` to unicode value of corresponding initial consonant.
    static private let jamosToInitialConsonantScalarValue: [[ConsonantJamo]: UInt32] = [
        [.giyeok]: 0x1100,
        [.giyeok, .giyeok]: 0x1101,
        [.nieun]: 0x1102,
        [.digeut]: 0x1103,
        [.digeut, .digeut]: 0x1104,
        [.rieul]: 0x1105,
        [.mieum]: 0x1106,
        [.bieup]: 0x1107,
        [.bieup, .bieup]: 0x1108,
        [.siot]: 0x1109,
        [.siot, .siot]: 0x110A,
        [.ieung]: 0x110B,
        [.jieut]: 0x110C,
        [.jieut, .jieut]: 0x110D,
        [.chieut]: 0x110E,
        [.kieuk]: 0x110F,
        [.tieut]: 0x1110,
        [.pieup]: 0x1111,
        [.hieut]: 0x1112
    ]

    /// Dictionary to map an array of ``Jamo`` to unicode value of corresponding vowel.
    static private let jamosToVowelScalarValue: [[VowelJamo]: UInt32] = [
        [.a]: 0x1161,
        [.ae]: 0x1162,
        [.ya]: 0x1163,
        [.yae]: 0x1164,
        [.eo]: 0x1165,
        [.e]: 0x1166,
        [.yeo]: 0x1167,
        [.ye]: 0x1168,
        [.o]: 0x1169,
        [.wa]: 0x116A,
        [.wae]: 0x116B,
        [.oe]: 0x116C,
        [.yo]: 0x116D,
        [.u]: 0x116E,
        [.wo]: 0x116F,
        [.we]: 0x1170,
        [.wi]: 0x1171,
        [.yu]: 0x1172,
        [.eu]: 0x1173,
        [.ui]: 0x1174,
        [.i]: 0x1175
    ]

    /// Dictionary to map an array of ``Jamo`` to unicode value of corresponding final consonant.
    static private let jamosToFinalConsonantScalarValue: [[ConsonantJamo]: UInt32] = [
        [.giyeok]: 0x11A8,
        [.giyeok, .giyeok]: 0x11A9,
        [.giyeok, .siot]: 0x11AA,
        [.nieun]: 0x11AB,
        [.nieun, .jieut]: 0x11AC,
        [.nieun, .hieut]: 0x11AD,
        [.digeut]: 0x11AE,
        [.rieul]: 0x11AF,
        [.rieul, .giyeok]: 0x11B0,
        [.rieul, .mieum]: 0x11B1,
        [.rieul, .bieup]: 0x11B2,
        [.rieul, .siot]: 0x11B3,
        [.rieul, .tieut]: 0x11B4,
        [.rieul, .pieup]: 0x11B5,
        [.rieul, .hieut]: 0x11B6,
        [.mieum]: 0x11B7,
        [.bieup]: 0x11B8,
        [.bieup, .siot]: 0x11B9,
        [.siot]: 0x11BA,
        [.siot, .siot]: 0x11BB,
        [.ieung]: 0x11BC,
        [.jieut]: 0x11BD,
        [.chieut]: 0x11BE,
        [.kieuk]: 0x11BF,
        [.tieut]: 0x11C0,
        [.pieup]: 0x11C1,
        [.hieut]: 0x11C2
    ]
}
