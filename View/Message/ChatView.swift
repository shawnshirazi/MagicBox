//
//  ChatView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/13/23.
//

import SwiftUI
import Introspect

struct ChatView: View {
    @ObservedObject var chatMng: ChatManager
    
    @State private var typingMessage: String = ""
    
    @State private var scrollProxy: ScrollViewProxy? = nil
    @EnvironmentObject var bleManager: BLEManager

    
    private var person: Person

    init(person: Person) {
        self.person = person
        self.chatMng = ChatManager(person: person)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer().frame(height: 60)
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    ScrollViewReader { proxy in
                        
                        LazyVStack {
                            ForEach(chatMng.messages.indices, id: \.self) { index in
                                let msg = chatMng.messages[index]
                                MessageView(message: msg)
                                    .id(index)
                            }
                        }
                        .onAppear(perform: {
                            scrollProxy = proxy
                        })
                    }
                })
                
                ZStack(alignment: .trailing) {
                    Color.textfieldBG
                    
                    TextField("Type a message", text: $typingMessage)
                        .foregroundColor(Color.textPrimary)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(height: 45)
                        .padding(.horizontal)
                    
                    Button(action: {
                        bleManager.sendMessagePartner1Message { msg in
                            print(msg)
                        }},
                           label: {
                        Text("Send")
                    })
                    .padding(.horizontal)
                    .foregroundColor(typingMessage.isEmpty ? Color.textPrimary : Color.blue )
                    
                }
                .frame(height: 40)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            ChatViewHeader(
                name: person.name)
        }
        .modifier(HideNavigationView())
        .onChange(of: chatMng.keyboardIsShowing, perform: { value in
            if value {
                scrollToBottom()
            }
        })
        .onChange(of: chatMng.messages, perform: { _ in
            scrollToBottom()
        })
    }
    
    func sendMessage() {
        chatMng.sendMessage(Message(content: typingMessage))
        typingMessage = ""
    }
    
    func scrollToBottom() {
        withAnimation {
            scrollProxy?.scrollTo(chatMng.messages.count - 1, anchor: .bottom)
        }
    }
    
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(person: Person.example)
//    }
//}
