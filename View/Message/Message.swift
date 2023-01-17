//
//  Message.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/13/23.
//

import Foundation


struct Message: Hashable {
    var content: String
    var person: Person? = nil
    
    var fromCurrentUser: Bool {
        return person == nil
    }
}

extension Message {
    static let exampleSent = Message(content: "Hello there")
    static let exampleReceived = Message(content: "Hello there", person: Person.example)
}
