//
//  String+.swift
//
//
//  Created by Kazumasa Wakamori on 2022/12/04.
//

import Foundation

extension String {
    /// Romanized given hangul word by following the Revised Romanization of Korean rule.
    /// https://www.korean.go.kr/front_eng/roman/roman_01.do
    /// - Parameter separator: A string to be used as a separator
    /// - Returns: Romanized string
    func romanized(separator: String = " ") -> String {
        let splitted = split(text: self)
        var result = ""
        for subString in splitted {
            if let hangul = try? HangulString(subString) {
                result += hangul.romanized(separator: separator)
            } else {
                result += subString
            }
        }

        return result
    }

    /// Katakanize given hangul word by following the Revised Romanization of Korean rule.
    /// - Returns: Katakanized string
    func katakanize() -> String {
        let splitted = split(text: self)
        var result = ""
        for subString in splitted {
            if let hangul = try? HangulString(subString), let kana = try? hangul.katakanize() {
                result += kana
            } else {
                result += subString
            }
        }

        return result
    }

    /// Split `text` into an array of strings containing hangul and non-hangul parts respectively.
    /// - Parameter text: A string to split
    /// - Returns: An array of strings containing hangul and non-hangul parts respectively.
    private func split(text: String) -> [String] {
        var result: [String] = []
        var currentString = ""
        var isLastCharHangul: Bool?

        for char in text {
            let isHangul = char.isHangulJamos || char.isHangulSyllable
            if let isLastCharHangul = isLastCharHangul, isHangul != isLastCharHangul {
                result.append(currentString)
                currentString = ""
            }

            currentString.append(char)
            isLastCharHangul = isHangul
        }

        result.append(currentString)
        return result
    }
}
