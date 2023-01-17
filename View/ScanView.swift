//
//  ScanView.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/5/23.
//

import SwiftUI
import CoreBluetooth

struct ScanView: View {
    
    @State private var isScanning: Bool = false
//    @ObservedObject var bleManager = BLEManager()
    @EnvironmentObject var bleManager: BLEManager

        var body: some View {
            NavigationView {
                VStack (spacing: 10) {
         
                    List(Array(bleManager.devices.enumerated()), id: \.offset) { index, device in
//                    ForEach(bleManager.devices) { device in

                        NavigationLink(destination: CompassView(device: device), label: {
                            HStack {
                                Text(device.name)
                                Spacer()
                                Text(String(device.rssi))
                            }
                        })
                    }
                    .listStyle(.grouped)
                }
                .navigationTitle("Devices")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        if (!isScanning) {
                            Button {
                                self.bleManager.startScanning()
                                isScanning = true
                            } label: {
                                Text("Scan")
                            }
                        } else {
                            Button(action: {
                                self.bleManager.stopScanning()
                                isScanning = false
                            }) {
                                Text("Stop Scanning")
                            }
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Settings") {
                        }
                    }
                }
            }
        }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}
