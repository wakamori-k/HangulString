//
//  Romanization.swift
//  
//
//  Created by 若森和昌 on 2022/03/30.
//

struct Romanization {
    
    static let onset: [String] = [
        "g", "kk", "n", "d", "tt",
        "r", "m", "b", "pp", "s",
        "ss", "",  "j", "jj", "ch",
        "k", "t", "p", "h"
    ]
    
    static let nucleus: [String] = [
        "a", "ae", "ya", "yae","eo",
        "e", "yeo", "ye", "o",  "wa",
        "wae", "oe", "yo", "u",  "wo",
        "we", "wi", "yu", "eu", "ui",
        "i"
    ]
    
    static let coda: [String] = [
        "", "g", "k", "gs", "n",
        "nj", "nh", "t", "l", "lg",
        "lm", "lb", "ls", "lt", "lp",
        "lh", "m", "b", "bs", "s",
        "ss", "ng", "j", "ch", "k",
        "t", "p", "h"
    ]
    
}
