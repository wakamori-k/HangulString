//
//  Romanization.swift
//  
//
//  Created by 若森和昌 on 2022/03/30.
//

struct Romanization {
    
    /// Romanizations of initial consonants in hangul.
    static let choseong: [String] = [
        "g", "kk", "n", "d", "tt",
        "r", "m", "b", "pp", "s",
        "ss", "",  "j", "jj", "ch",
        "k", "t", "p", "h"
    ]
    
    /// Romanizations of medial vowels in hangul.
    static let jungseong: [String] = [
        "a", "ae", "ya", "yae","eo",
        "e", "yeo", "ye", "o",  "wa",
        "wae", "oe", "yo", "u",  "wo",
        "we", "wi", "yu", "eu", "ui",
        "i"
    ]
    
    /// Romanizations of final consonants in hangul.
    static let jongseong: [String] = [
        "", "g", "k", "gs", "n",
        "nj", "nh", "t", "l", "lg",
        "lm", "lb", "ls", "lt", "lp",
        "lh", "m", "b", "bs", "s",
        "ss", "ng", "j", "ch", "k",
        "t", "p", "h"
    ]
    
}
