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
        let romans = self.map { $0.romanized() }
        return romans.joined(separator: separator)
    }
}
