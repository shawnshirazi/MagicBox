//
//  MessageListView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/13/23.
//

import SwiftUI
import Introspect

struct MessageListView: View {
    @ObservedObject var vm: MessageListVM = MessageListVM()
    
    @State private var searchText: String = ""
    @State private var isEditing: Bool = false
    @State private var tabBar: UITabBar! = nil
    var person: Person = Person.example

    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 3) {
                    
                    NavigationLink(destination: ChatView(person: person)) {
                        MessageRowView(person: person)
                    }
                    
                    
//                    ZStack {
//                        VStack {
//                            ForEach(vm.messagePreviews.filter({ searchText.isEmpty ? true : displayPreview($0) }), id: \.self) { preview in
//
//                                NavigationLink(
//                                    destination: ChatView(person: preview.person),
////                                        .onAppear { self.tabBar.isHidden = true }
////                                        .onDisappear { self.tabBar.isHidden = false },
//                                    label: {
//                                        MessageRowView(preview: preview)
//                                    })
//                                .buttonStyle(PlainButtonStyle())
//                                .animation(.easeIn(duration: 0.25))
//                                .transition(.slide)
//                            }
//                        }
//                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func displayPreview(_ preview: MessagePreview) -> Bool {
        // person name
        if preview.person.name.contains(searchText) { return true }
        
        // last message sent
        if preview.lastMessage.contains(searchText) { return true }
        
            
        return false
    }
    
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MessageListView()
        }
    }
}
