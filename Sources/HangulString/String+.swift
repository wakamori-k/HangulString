//
//  String+.swift
//  
//
//  Created by Kazumasa Wakamori on 2022/12/04.
//

import Foundation

public extension String {
    func romanized(separator: String = " ") -> String {
        let romans = self.map { $0.romanized() }
        return romans.joined(separator: separator)
    }
}
