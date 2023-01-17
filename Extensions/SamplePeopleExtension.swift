//
//  SamplePeopleExtension.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/8/23.
//

import Foundation
import SwiftUI
extension Person {
    static let example = Person(name: "Paymon", color: Color.red, rssi: "Strong", distance: "20 ft away")
    static let example2 = Person(name: "Soroosh", color: Color.blue, rssi: "String", distance: "21 ft away")
    
    static let examples: [Person] = [
        Person.example,
        Person.example2,
        Person(name: "Shawn", color: Color.green, rssi: "medium", distance: "50 ft away"),
        Person(name: "Amin", color: Color.brown, rssi: "weak", distance: "100 ft away")
    ]
}
