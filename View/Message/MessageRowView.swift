//
//  MessageRowView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/13/23.
//

import SwiftUI

struct MessageRowView: View {
    var person: Person
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 50, height: 50)
                        .padding(.trailing)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text(person.name)
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .semibold))
                            
                            Spacer()
                            
                            Text("12:20 PM")
                                .foregroundColor(.gray)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                        HStack {
                            Text(person.distance)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            Spacer()
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.leading, 90)
                
            }
            
            VStack {
                HStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 50, height: 50)
                        .padding(.trailing)
                    
                    VStack(spacing: 9) {
                        HStack {
                            Text(person.name)
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .semibold))
                            
                            Spacer()
                            
                            Text("Tueday")
                                .foregroundColor(.gray)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        
                        HStack {
                            Text(person.distance)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            Spacer()
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.leading, 90)
                
            }
        }
        
    }
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageRowView(person: Person.example)
    }
}
