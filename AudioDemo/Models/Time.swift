//
//  Time.swift
//  AudioDemo
//
//  Created by Duc Canh on 20/06/2023.
//

import Foundation

@propertyWrapper
struct TimeValue {
    var value: Int = 0
    var wrappedValue: Int {
        get {
            return value
        }
        set {
            value = newValue < 0 ? 0 : newValue
        }
    }

    func getString() -> String {
        return value < 10 ? "0\(value)" : String(value)
    }
}

struct TimePlayer {
    @TimeValue var hours
    @TimeValue var minutes
    @TimeValue var seconds

    func getTimerString() -> String {
        if hours == 0 {
            return "\(_minutes.getString()):\(_seconds.getString())"
        } else {
            return "\(_hours.getString()):\(_minutes.getString()):\(_seconds.getString())"
        }
    }

    func totalSeconds() -> Int {
        return hours * 60 * 60 + minutes * 60 + seconds
    }
}
