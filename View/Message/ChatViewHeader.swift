//
//  ChatViewHeader.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/13/23.
//

import SwiftUI

struct ChatViewHeader: View {
    @Environment(\.presentationMode) var presentationMode
    
    let name: String
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.top)
                .shadow(radius: 3)
            
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 28, weight: .semibold))
                })
                
                Spacer()
                
                
                Text(name)
                
                    .font(.system(size: 14))
                
                
                Spacer()
                
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 10)
        }
        .frame(height: 50)
    }
}

struct ChatViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        let person = Person.example
        ChatViewHeader(
            name: person.name
        )
    }
}
