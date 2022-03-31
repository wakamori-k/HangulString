//
//  Character+.swift
//
//
//  Created by 若森和昌 on 2022/03/30.
//

/// A type that can operate a character as hangul.
protocol HangulProtocol {
    var isHangulSyllable: Bool { get }
    var jamos: [Unicode.Scalar]? { get }
    var romanized: String { get }
}

extension Character: HangulProtocol {
    
    var isHangulSyllable: Bool {
        
        guard unicodeScalars.count == 1 else {
            return false
        }
        
        guard let first = unicodeScalars.first,
              Unicode.Scalar.hangulSyllableRange ~= first else {
                    return false
        }
        
        return true
    }
    
    var jamos: [Unicode.Scalar]? {
        
        guard self.unicodeScalars.count <= 1 else {
            // Check Hangul Jamo or not
            // https://unicode-table.com/en/blocks/hangul-jamo/
            let ranges = [UInt32(0x1100)...UInt32(0x1112),
                          UInt32(0x1161)...UInt32(0x1175),
                          UInt32(0x11A8)...UInt32(0x11C2)]
            
            for (i, value) in unicodeScalars.map({$0.value}).enumerated() {
                guard ranges[i] ~= value else {
                    return nil
                }
            }
            
            return self.unicodeScalars.map { Unicode.Scalar($0) }
        }
        
        // Check hangul syllable or not
        // https://unicode-table.com/en/blocks/hangul-syllables/
        guard let first = self.unicodeScalars.first,
              Unicode.Scalar.hangulSyllableRange ~= first else {
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
    
    var romanized: String {
        
        guard let jamos = jamos else {
            return String(self)
        }
        
        var romanized = ""
        if jamos.count > 0 {
            romanized.append(
                Romanization.choseong[Int(jamos[0].value) - 0x1100]
            )
        }
        
        if jamos.count > 1 {
            romanized.append(
                Romanization.jungseong[Int(jamos[1].value) - 0x1161]
            )
        }
        
        if jamos.count > 2 {
            romanized.append(
                Romanization.jongseong[Int(jamos[2].value) - 0x11A7]
            )
        }
        
        return romanized
    }

}
