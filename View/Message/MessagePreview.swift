//
//  MessagePreview.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/13/23.
//

import Foundation

struct MessagePreview: Hashable {
    var person: Person
    var lastMessage: String
}

extension MessagePreview {
    static let example = MessagePreview(person: Person.example, lastMessage: "Hello there. How are you doing today? How's the weather where you live right now?")
    
    static let examples: [MessagePreview] = [
        MessagePreview(person: Person.example, lastMessage: "Hello there. How are you doing today? How's the weather where you live right now?"),
        MessagePreview(person: Person.example2, lastMessage: "Hi there")
    ]
}
