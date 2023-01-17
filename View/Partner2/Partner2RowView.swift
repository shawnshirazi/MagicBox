//
//  Partner2RowView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/12/23.
//

import SwiftUI

struct Partner2RowView: View {
    @EnvironmentObject var bleManager: BLEManager
    
    @State var p2Address: String = ""
    @State var p2Distance: String = ""
    @State var p2RSSI: String = ""
    @State private var hasTimeElapsed = false
    @State var newInterval = 1

    var body: some View {
        VStack {
            
            if hasTimeElapsed {
                HStack {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                    
                    Text(p2Address)
                    
                    Spacer()
                    
                    Text(p2RSSI)
                    
                    Text(p2Distance)
                    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                partner2Address()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                partner2Distance()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                partner2RSSI { val in
                    if val {
                        hasTimeElapsed = true
                    }
                }
            }
        }
    }
    
    func partner2Address() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(newInterval), repeats: false) { timer in
            bleManager.getPartner2Address { address in
                print("address is \(address)")
                let partner2Address = address as! String
                p2Address = partner2Address
            }
            if bleManager.myPeripheral == nil {
                timer.invalidate()
            }
        }
    }
    
    func partner2Distance() {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(newInterval), repeats: true) { timer in
            bleManager.getPartner2Distance { distance in
                print("distance is \(distance)")
                let dist = distance as! String
                p2Distance = dist
            }
            if bleManager.myPeripheral == nil {
                timer.invalidate()
            }
        }
    }
    
    func partner2RSSI(completionHandler: @escaping (Bool) -> Void) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(newInterval), repeats: true) { timer in
            bleManager.getPartner2RSSI { rssi in
                print("rssi is \(rssi)")
                let rssi = rssi as! String
                p2RSSI = rssi
                completionHandler(true)
            }
            if bleManager.myPeripheral == nil {
                timer.invalidate()
            }
        }
    }
    
//    @Sendable private func delayPartner2Address() async {
//        try? await Task.sleep(nanoseconds: 5_000_000_000)
//        bleManager.getPartner2Address { address in
//            print("p2 address is \(address)")
//            let partner2Address = address as! String
//            p2Address = partner2Address
//        }
//    }
//
//    @Sendable private func delayPartner2Distance() async {
//        try? await Task.sleep(nanoseconds: 6_000_000_000)
//        bleManager.getPartner2Distance { distance in
//            print("p2 distance is \(distance)")
//            let dist = distance as! String
//            p2Distance = dist
//        }
//    }
//
//    @Sendable private func delayPartner2RSSI() async {
//        try? await Task.sleep(nanoseconds: 7_000_000_000)
//        bleManager.getPartner2RSSI { rssi in
//            print("p2 rssi is \(rssi)")
//            let rssi = rssi as! String
//            p2RSSI = rssi
//        }
//        hasTimeElapsed = true
//    }
}

//struct Partner2RowView_Previews: PreviewProvider {
//    static var previews: some View {
//        Partner2RowView()
//    }
//}
