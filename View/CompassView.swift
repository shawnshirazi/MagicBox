//
//  CompassView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/5/23.
//

import SwiftUI

struct CompassView: View {
    
    var device: Device
    var isConnected: Bool = false
    @EnvironmentObject var bleManager: BLEManager
    
    @Environment(\.presentationMode) var presentation
    
    @State private var connected = false
    
    @State private var hasTimeElapsed = false
    @State private var hasTimeElapsed2 = false

    
    let string = "0"
    let str = String(describing: "0".cString(using: String.Encoding.utf8))
    
    let bytes : [UInt8] = [0]
    let data0 = Data("0".utf8)
    let data1 = Data("1".utf8)
    
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var pD: String = ""

    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 35) {
    
                Compass()
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                
                
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                
                Partner1RowView()
                Partner2RowView()

                    
            }
            .navigationBarBackButtonHidden(true)
            .navigationTitle(device.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Disconnect") {
                        bleManager.disconnect(device: device)
                        self.presentation.wrappedValue.dismiss()

                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                    }
                }
            }
            .onAppear {
                bleManager.connect(device: device)
                connected = true
            }
            .onChange(of: device.peripheral.state.rawValue) { newValue in
                if newValue == 0 {
                    self.presentation.wrappedValue.dismiss()
                }
//                print(device.peripheral)
//                print(device.peripheral.state.rawValue)
            }
//            .onChange(of: bleManager.deviceConnection) { connection in
//                if connection{
//                    bleManager.writeToCommand(device: device, data: data0) { val in
//                        if val == true {
//                            write = true
//                        }
//                    }
//                }
//            }

        }
    }
    
//    private func delayLat() async {
//        // Delay of 7.5 seconds (1 second = 1_000_000_000 nanoseconds)
//        try? await Task.sleep(nanoseconds: 1_000_000_000)
//        bleManager.getLatitude { val in
//            print("lat is \(val)")
//            let lat = val as! String
//            latitude = lat
//        }
//        hasTimeElapsed = true
//    }
//    
//    private func delayLong() async {
//        try? await Task.sleep(nanoseconds: 1_500_000_000)
//        bleManager.getLongitude { val in
//            print("long is \(val)")
//            let long = val as! String
//            longitude = long
//        }
//
////        hasTimeElapsed = true
//    }
}

//struct CompassView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompassView()
//    }
//}
