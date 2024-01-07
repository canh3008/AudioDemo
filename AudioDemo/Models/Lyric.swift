//
//  Lyric.swift
//  AudioDemo
//
//  Created by Duc Canh on 18/07/2023.
//

import Foundation

class Lyric {
    var text: String
    var isBlur: Bool = false

    init(text: String, isBlur: Bool = false) {
        self.text = text
        self.isBlur = isBlur
    }
}
