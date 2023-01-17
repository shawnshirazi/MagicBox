//
//  Partner1RowView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/11/23.
//

import SwiftUI

struct Partner1RowView: View {
    
    @EnvironmentObject var bleManager: BLEManager
    
    @State var p1Address: String = ""
    @State private var hasTimeElapsed = false
    @State var p1Distance: String = ""
    @State var p1RSSI: String = ""
    @State var newInterval = 1

    var body: some View {
        VStack {
            
            if hasTimeElapsed {
                HStack {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                    
                    Text(p1Address)
                    
                    Spacer()
                    
                    Text(p1RSSI)
                    
                    Text(p1Distance)
                    
                    Text("m away")
                    
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .padding(.leading)
                    
                    
                }
                .padding(.horizontal)
            } else {
                HStack {
                    Text("Loading...")
                }
            }
            
            Divider()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                partner1Address()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                partner1Distance()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                partner1RSSI { val in
                    if val {
                        hasTimeElapsed = true
                    }
                }
            }
        }
    }
    
    func partner1Address() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(newInterval), repeats: false) { timer in
            bleManager.getPartner1Address { address in
                print("address is \(address)")
                let partner1Address = address as! String
                p1Address = partner1Address
//                newInterval = 10
            }
            if bleManager.myPeripheral == nil {
                timer.invalidate()
            }
        }
    }
    
    func partner1Distance() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(newInterval), repeats: true) { timer in
            bleManager.getPartner1Distance { distance in
                print("distance is \(distance)")
                let dist = distance as! String
                p1Distance = dist
            }
            if bleManager.myPeripheral == nil {
                timer.invalidate()
            }
        }
    }
    
    func partner1RSSI(completionHandler: @escaping (Bool) -> Void) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(newInterval), repeats: true) { timer in
            bleManager.getPartner1RSSI { rssi in
                print("rssi is \(rssi)")
                let rssi = rssi as! String
                p1RSSI = rssi
                completionHandler(true)
            }
            if bleManager.myPeripheral == nil {
                timer.invalidate()
            }
        }
    }


    
    
//    @Sendable private func delayPartner1Address() async {
//        try? await Task.sleep(nanoseconds: 1_000_000_000)
//        bleManager.getPartner1Address { address in
//            print("address is \(address)")
//            let partner1Address = address as! String
//            p1Address = partner1Address
//        }
//    }
//
//    @Sendable private func delayPartner1Distance() async {
//        try? await Task.sleep(nanoseconds: 1_000_000_000)
//        bleManager.getPartner1Distance { distance in
//            print("distance is \(distance)")
//            let dist = distance as! String
//            p1Distance = dist
//        }
//    }
//
//    @Sendable private func delayPartner1RSSI() async {
//        try? await Task.sleep(nanoseconds: 1_000_000_000)
//        bleManager.getPartner1RSSI { rssi in
//            print("rssi is \(rssi)")
//            let rssi = rssi as! String
//            p1RSSI = rssi
//        }
//        hasTimeElapsed = true
//    }
}

//struct Partner1RowView_Previews: PreviewProvider {
//    static var previews: some View {
//        Partner1RowView()
//    }
//}
