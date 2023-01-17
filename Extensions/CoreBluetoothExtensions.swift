//
//  CoreBluetoothExtensions.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/9/23.
//

import Foundation
import CoreBluetooth

extension CBPeripheral {
    
    var writeChacteristic: CBCharacteristic? {
        return self.services?[0].characteristics?[0]
    }
    
    var notifyCharacteristics: CBCharacteristic? {
        return self.services?[0].characteristics?[1]
    }
}
