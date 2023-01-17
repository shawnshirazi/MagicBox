//
//  PersonListView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/8/23.
//

import SwiftUI

struct PersonListView: View {
    var person: [Person] = Person.examples
    var body: some View {
        VStack{
            ForEach(person, id: \.self) { person in
                PersonRowView(person: person)
                    .frame(height: 35)
                
                Divider()

            }
        }
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView()
    }
}

struct Person: Hashable, Identifiable {
    let id = UUID().uuidString

    let name: String
    let color: Color
    let rssi: String
    let distance: String
}
