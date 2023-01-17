//
//  MessageVM.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/13/23.
//

import Foundation

class MessageListVM: ObservableObject {
    @Published var messagePreviews: [MessagePreview] = []
    
    init() {
        loadPreviews()
    }
    
    func loadPreviews() {
        // Handle networking to load messagePreviews from a server
        self.messagePreviews = MessagePreview.examples
    }
}
