//
//  HangulString.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/05.
//

public struct HangulString {
    public typealias Element = HangulCharacter
    private var content: [Element] = []
    private static let converterClasses: [PhonologicalConverter.Type] = [
        // TODO: Optimize the conversion order
        PalatalisationConverter.self,
        ResyllabificationConverter.self,
        ReinforcementConverter.self,
        NasalisationConverter.self,
        AssimilationConverter.self,
        EndingConsonantSimplificationConverter.self,
        AspirationConverter.self
    ]

    /// Creates a new hangul string containing the given string.
    /// - Parameter string: A string instance
    public init(_ string: String) throws {
        for c in string {
            do {
                content.append(try HangulCharacter(c))
            } catch {
                throw HangulStringError.invalidCharacter
            }
        }
    }

    public init<S>(_ characters: S) where S: Sequence, S.Element == Element {
        content = [Element](characters)
    }

    /// Romanizes the hangul string by following the Revised Romanization of Korean rule.
    /// https://www.korean.go.kr/front_eng/roman/roman_01.do
    /// - Parameter separator: A string to be used as a separator
    /// - Returns: Romanized string
    public func romanized(separator: String = " ") -> String {
        let romans = content.map { $0.romanized() }
        return romans.joined(separator: separator)
    }

    /// Converts the Hangul string to its katakanized representation.
    ///
    /// This function takes the Hangul string and processes it through a phonological conversion process
    /// to handle specific character transformations. After the phonological conversion,
    /// each character is processed to generate the corresponding katakanized characters.
    /// Consecutive occurrences of the character "ッ" are reduced to a single instance.
    ///
    /// - Returns: A `String` representing the katakanized version of the Hangul string.
    /// - Throws: An error if the phonological conversion process fails.
    public func katakanize() throws -> String {
        let converted = try SilenationHieutConverter.convert(hangulString: self)
        var katakanized = ""
        for (i, c) in converted.content.enumerated() {
            katakanized += c.katakanize(vocalize: i > 0)
        }
        // Remove consecutive "ッ"
        katakanized = katakanized.replacingOccurrences(of: "ッッ", with: "ッ")
        return katakanized
    }

    /// Converts the `HangulString` to its phonological representation in Katakana.
    ///
    /// This function performs the following steps:
    /// 1. Converts the input Hangul string into its phonological representation using `SilenationHieutConverter`.
    /// 2. Iterates through each character of the phonological representation.
    /// 3. Transforms each character into its corresponding Katakana representation.
    /// 4. Removes any duplicated "ッ" characters.
    ///
    /// - Throws: An error if the conversion by `SilenationHieutConverter` fails.
    /// - Returns: A `String` containing the Katakana representation of the input Hangul string.
    public func pronounceInKatakana() throws -> String {
        return try phonologicalConverted().katakanize()
    }

    /// Converts the hangul string based on on the phonological rules.
    /// - Returns: Converted string in hangul.
    public func phonologicalConverted() throws -> HangulString {
        var hs = self
        for converterClass in HangulString.converterClasses {
            hs = try converterClass.convert(hangulString: hs)
        }
        return hs
    }

    /// Converts the hangul string to `String` type.
    /// - Returns: Converted string.
    public func toString() -> String {
        return String(content.map { $0.toSyllableCharacter() })
    }
}

extension HangulString: Collection {

    public var startIndex: Int {
        return content.startIndex
    }

    public var endIndex: Int {
        return content.endIndex
    }

    public func index(after i: Int) -> Int {
        return content.index(after: i)
    }

    public subscript(position: Int) -> Element {
        get {
            return content[position]
        }
        set (newValue) {
            content[position] = newValue
        }
    }

    public func makeIterator() -> IndexingIterator<[Element]> {
        return content.makeIterator()
    }
}

extension HangulString: Comparable {
    public static func < (lhs: HangulString, rhs: HangulString) -> Bool {
        return lhs.toString() < rhs.toString()
    }
}

extension HangulString: Equatable {
    public static func == (lhs: HangulString, rhs: HangulString) -> Bool {
        return lhs.toString() == rhs.toString()
    }
}
