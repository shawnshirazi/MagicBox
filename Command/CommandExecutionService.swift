////
////  CommandExecutionService.swift
////  MagicBoxV2
////
////  Created by Shawn Shirazi on 1/10/23.
////
//
//import Foundation
//import CoreBluetooth
//
//class CommandExecutionService: NSObject, CBPeripheralDelegate, ObservableObject, ICommandExecutionService {
//    
//    var communicationPeripheral: CBPeripheral?
//    
//    func resetPeripheral() {
////        if peripheral != nil {
////            self.peripheral.delegate = self
////            self.peripheral.setNotifyValue(true, for: self.peripheral.notifyCharacteristics!)
////        }
//    }
//    
//    var deviceDisconnected: (() -> Void)?
//    
//
//    var peripheral: CBPeripheral!
//    var bleManager: BLEManager
////    static var BLE_WRITE_CHARACTERISTIC: CBUUID = CBUUID(string: "b1945fa2-981b-490a-9e85-f831c5bf06e2")
////    static var BLE_SERVICE_UUID: CBUUID = CBUUID(string: "b1945fa1-981b-490a-9e85-f831c5bf06e2")
////    static var BLE_NOTIFY_CHARACTERISTIC: CBUUID = CBUUID(string: "b1945fa3-981b-490a-9e85-f831c5bf06e2")
////    var txCharacteristic: CBCharacteristic? = nil
////    var rxCharacteristic: CBCharacteristic? = nil
//    
//    private var awaitingResponse: Bool = false
//    private var cachedCommand: CommandBase!
//    private var retryAttempt = 0
//    private var cachedCompletionHandler : ((Any) -> Void)?
//    
////    var device: Device
//    
//    init(bleManager: BLEManager) {
//        self.bleManager = bleManager
//        super.init()
////        if peripheral != nil {
////            self.peripheral.delegate = self
////            self.peripheral.setNotifyValue(true, for: self.peripheral.notifyCharacteristics!)
////        }
//    }
//
////    init(peripheral: CBPeripheral?, bleManager: BLEManager) {
////        self.bleManager = bleManager
////        self.peripheral = peripheral
////        super.init()
//////        if peripheral != nil {
//////            self.peripheral.delegate = self
//////            self.peripheral.setNotifyValue(true, for: self.peripheral.notifyCharacteristics!)
//////        }
////    }
//
//
//    private func executeCommand(command: CommandBase, completionHandler: @escaping (Any) -> Void) {
//        
//        writeToCommand(data: command.txData)
//    }
//    
//    func getLatitude(completionHandler: @escaping (Any) -> Void) {
//        var com = GetLatitude()
//        executeCommand(command: com, completionHandler: completionHandler)
//    }
//
//
//    func writeToCommand(data: Data) {
//        
////        print(rxCharacteristic)
////        print(txCharacteristic)
////        if self.peripheral.writeChacteristic == nil || self.peripheral == nil {
////            print("error sending")
////
////        } else {
////            self.peripheral.writeValue(data, for: self.peripheral.writeChacteristic!, type: .withResponse)
//////            device.peripheral.writeValue(data, for: rxCharacteristic!, type: .withResponse)
////
//////            print(" PLEASE \(bleManager.txCharacteristic)")
////
////        }
//        if bleManager.txCharacteristic == nil  {
//
//            print("error sending")
//
//        } else {
//            bleManager.myPeripheral!.writeValue(data, for: bleManager.txCharacteristic!, type: .withResponse)
//        }
//    }
//    
////    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
////
//////        myPeripheral?.readValue(for: rxCharacteristic!)
//////        myPeripheral?.readValue(for: txCharacteristic!)
////        print("passss")
////        print("Char \(characteristic)")
////        guard let data = characteristic.value else { return }
////        print(data)
////
////        processResponse(data: data)
////
//////        let str = String(decoding: data, as: UTF8.self)
//////
//////        print(str)
//////
//////        self.myLocation0 = str
//////        self.myLocation1 = str
////
////
////
////
////        print("stop")
////    }
//    
//    func processResponse(data: Data) {
//        print("Awaiting response " + String(awaitingResponse))
//        print("For command: " + String(describing: cachedCommand))
//        retryAttempt = 0
//        if awaitingResponse {
//            print("Processing Repsonse")
//            var response: Any = 0
//            if self.cachedCommand.responseValueConverter != nil {
//                response = self.cachedCommand.convertResponseToValue(data: data)
//            }
//            
//            let ch = cachedCompletionHandler
//            ch?(response)
//        }
//    }
//}
