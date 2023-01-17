//
//  PersonRowView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/9/23.
//

import SwiftUI

struct PersonRowView: View {
    var person: Person = Person.example
    @EnvironmentObject var bleManager: BLEManager
    
    @State var p1Address: String = ""
    @State var p1Distance: String = ""


    var body: some View {
        
        HStack(spacing: 10) {
            Rectangle()
                .fill(person.color)
                .frame(width: 20, height: 20)

            Text(person.name)
            
            Spacer()
            
            Text(person.rssi)
            
            Text(person.distance)
            

            Image(systemName: "minus.circle.fill")
                .foregroundColor(.red)
            
        }
        .padding(.horizontal)
    }
}

struct PersonRowView_Previews: PreviewProvider {
    static var previews: some View {
        PersonRowView()
    }
}
