//
//  HangulStringError.swift
//
//
//  Created by Kazumasa Wakamori on 2024/05/06.
//

public enum HangulStringError: Error {
    case invalidStringLength
    case invalidCharacter
    case invalidUnicodeScalar
    case invalidJamoSequence
}
