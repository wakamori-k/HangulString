//
//  Constants.swift
//  
//
//  Created by 若森和昌 on 2022/03/31.
//

extension Unicode.Scalar {
    
    static let hangylSyllableStart: Self = Unicode.Scalar(UInt32(0xAC00))!
    static let hangylSyllableEnd: Self = Unicode.Scalar(UInt32(0xD7AF))!
    static let hangulSyllableRange = hangylSyllableStart...hangylSyllableEnd
    
}
