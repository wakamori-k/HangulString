//
//  Character+.swift
//
//
//  Created by 若森和昌 on 2022/03/30.
//

extension Character {
    
    /// A Boolean value indicating whether this character is a hangul syllable.
    var isHangulSyllable: Bool {
        
        guard unicodeScalars.count == 1 else {
            return false
        }
        
        guard let first = unicodeScalars.first,
              Unicode.Scalar.hangulSyllableRange.contains(first) else {
                    return false
        }
        
        return true
    }
    
    /// The hangul character's value represented as a collection of hangul jamos.
    ///
    /// Examples of representations as hangul jamo .
    /// ```
    /// '아' => ['ㅇ', 'ㅏ']
    /// '안' => ['ㅇ', 'ㅏ', 'ㄴ']
    /// ```
    var hangulJamos: [Unicode.Scalar]? {
        
        guard self.unicodeScalars.count <= 1 else {
            // Check Hangul Jamo or not
            // https://unicode-table.com/en/blocks/hangul-jamo/
            let ranges = [UInt32(0x1100)...UInt32(0x1112),
                          UInt32(0x1161)...UInt32(0x1175),
                          UInt32(0x11A8)...UInt32(0x11C2)]
            
            for (i, value) in unicodeScalars.map({$0.value}).enumerated() {
                guard ranges[i].contains(value) else {
                    return nil
                }
            }
            
            return self.unicodeScalars.map { Unicode.Scalar($0) }
        }
        
        // Check hangul syllable or not
        // https://unicode-table.com/en/blocks/hangul-syllables/
        guard let first = self.unicodeScalars.first,
              Unicode.Scalar.hangulSyllableRange.contains(first) else {
            return nil
        }

        let code = first.value - Unicode.Scalar.hangylSyllableStart.value
        let onset = (code - code % 28) / 28 / 21 + 0x1100
        let nucleus = (code - code % 28) / 28 % 21 + 0x1161
        var jamos = [onset, nucleus]
        if code % 28 > 0 {
            let coda: UInt32 = code % 28 + 0x11A7
            jamos.append(coda)
        }
        
        return jamos.compactMap{ Unicode.Scalar($0) }
    }
    
    /// Returns an romanized version of this hangul charactor.
    ///
    /// When this character is not hangul, returns the character casted to String.
    func romanized() -> String {
        
        guard let jamos = hangulJamos else {
            return String(self)
        }
        
        return jamos.map { $0.hangulRomanized ?? "" }.reduce("", +)
    }

}
