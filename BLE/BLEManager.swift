//
//  BLEManager.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/5/23.
//

import Foundation
import CoreBluetooth

struct Device: Identifiable {
    let peripheral: CBPeripheral
    let id: Int
    let name: String
    let rssi: Int
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var myCentral: CBCentralManager!
    @Published var isSwitchedOn = false
    @Published var deviceConnection = false
    @Published var devices: [Device] = []
    
    
    var isConnecting: Bool = false
    var isAttemptingReconnect: Bool = false
    
    @Published var myLocation0: String = ""
    @Published var myLocation1: String = ""
    
    var deviceDiscoveredHandler: ((ICommandExecutionService) ->Void)?
    
    var myPeripheral: CBPeripheral?
    public static let BLE_WRITE_CHARACTERISTIC: CBUUID = CBUUID(string: "b1945fa2-981b-490a-9e85-f831c5bf06e2")
    public static let BLE_SERVICE_UUID: CBUUID = CBUUID(string: "b1945fa1-981b-490a-9e85-f831c5bf06e2")
    public static let BLE_NOTIFY_CHARACTERISTIC: CBUUID = CBUUID(string: "b1945fa3-981b-490a-9e85-f831c5bf06e2")
    
    public static let ToFind: CBUUID = CBUUID(string: "1709")

    
    var txCharacteristic: CBCharacteristic? = nil
    var rxCharacteristic: CBCharacteristic? = nil


    private var received = false
    
    override init() {
        super.init()
 
        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
        
        myPeripheral?.setNotifyValue(true, for: (self.myPeripheral?.notifyCharacteristics)!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
         if central.state == .poweredOn {
             isSwitchedOn = true
             
         }
         else {
             isSwitchedOn = false
         }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
        var peripheralState: String!
        
        myPeripheral?.delegate = self
        

        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            peripheralName = name
        }
        else {
            peripheralName = "Unknown"
        }
        

        var newDevice = Device(peripheral: peripheral, id: devices.count, name: peripheralName, rssi: RSSI.intValue)
        myPeripheral = newDevice.peripheral
        myPeripheral!.delegate = newDevice.peripheral.delegate
        
        
        if !self.devices.contains(where: { $0.peripheral == newDevice.peripheral }) {
            self.devices.append(newDevice)
            print(newDevice)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connected")
        deviceConnection = true
        myPeripheral!.discoverServices([BLEManager.BLE_SERVICE_UUID])
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnected")
        myCentral.cancelPeripheralConnection(peripheral)
        deviceConnection = false
        myPeripheral = nil
        myPeripheral?.delegate = nil
    }
    
    func disconnect(device: Device) {
        myCentral.cancelPeripheralConnection(device.peripheral)
        print("disconnecting" + device.name)
        print(device)
    }
    
    
    func connect(device: Device) {
        myCentral.connect(device.peripheral, options: nil)
        
        myPeripheral = device.peripheral
        myPeripheral!.delegate = device.peripheral.delegate

        
        myCentral.stopScan()
        
        print("connecting to " + device.name)
        print(device)
        
        deviceConnection = true
    }
    
    func startScanning() {
        print("startScanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
     }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

            if ((error) != nil) {
                print("Error discovering services: \(error!.localizedDescription)")
                return
            }
            guard let services = peripheral.services else {
                return
            }
            for service in services {
                peripheral.discoverCharacteristics([BLEManager.BLE_WRITE_CHARACTERISTIC, BLEManager.BLE_NOTIFY_CHARACTERISTIC], for: service)
            }
            print("Discovered Services: \(services)")
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid == BLEManager.BLE_NOTIFY_CHARACTERISTIC {
                rxCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
            } else if (characteristic.uuid == BLEManager.BLE_WRITE_CHARACTERISTIC) {
                txCharacteristic = characteristic
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let value = characteristic.value {
            print("Char \(characteristic)")
            processResponse(data: value)

        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("1")
    }

    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("2")
    }
    
    
    
    
    // MARK: - COMMAND EXECUTION SERVICE
    
    private var awaitingResponse: Bool = false
    private var cachedCommand: CommandBase!
    private var retryAttempt = 0
    private var badState = false
    private var cachedCompletionHandler : ((Any) -> Void)?
    private var commandBuffer: [(CommandBase, (Any) -> Void)] = []
    var timeOutTimer = Timer()
    var deviceDisconnected: (() -> Void)?
    
    private func executeCommand(command: CommandBase, completionHandler: @escaping (Any) -> Void) {
        if badState {
            print("bad state true in execute command")
        }
        
        if !awaitingResponse {
            print(String(describing: command))
            cachedCommand = command
            cachedCompletionHandler = completionHandler
            awaitingResponse = true
            
            writeToCommand(data: command.txData)
            
            timeOutTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimeOut), userInfo: nil, repeats: false)
        }
        else if !badState {
            checkDeviceConnection()
//            commandBuffer.append((commandBuffer, completionHandler))
        }
        
        
    }
    
    func writeToCommand(data: Data) {
        if txCharacteristic == nil || myPeripheral == nil  {
            if !badState {
                print("error sending")
                badState = true
                timeOutTimer.invalidate()
            }
        } else {
            myPeripheral?.writeValue(data, for: txCharacteristic!, type: .withResponse)
        }
    }
    
    private func processResponse(data: Data) {
        timeOutTimer.invalidate()
        
        print("Awaiting response " + String(awaitingResponse))
        print("For command: " + String(describing: cachedCommand))
        retryAttempt = 0
        if awaitingResponse {
            print("Processing Repsonse")
            var response: Any = 0
            if self.cachedCommand.responseValueConverter != nil {
                response = self.cachedCommand.convertResponseToValue(data: data)
            }
            
            let ch = cachedCompletionHandler
            ch?(response)
            print(response)
            
            self.awaitingResponse = false
            self.cachedCommand = nil
            self.popCommandBufferQueue()
        }
    }
    
    private func popCommandBufferQueue() {
        if let top: (CommandBase, (Any) -> Void) = commandBuffer.first {
            print("Popping Top: " + String(describing: top))
            commandBuffer.remove(at: 0)
            executeCommand(command: top.0, completionHandler: top.1)
        }
    }
    
    private func checkDeviceConnection(){
        if !badState && myPeripheral?.state != CBPeripheralState.connected {
            print("bad state check connection")
            badState = true
            deviceDisconnected?()
        }
    }
    
    @objc func handleTimeOut(){
        if badState {
            print("bad state trigger in handle timeout")
            awaitingResponse = false
            return
        }
        print("Timeout occured")
        print("Is Valid: " + String(self.timeOutTimer.isValid))
        
        if retryAttempt <= 5 {
            if badState {
                awaitingResponse = false
                return
            }
            retryAttempt = 1
            if self.timeOutTimer.isValid {
                if self.cachedCompletionHandler != nil {
                    self.commandBuffer.append((self.cachedCommand, self.cachedCompletionHandler!))
                }
            }
        }
        else {
            retryAttempt = 0
        }
        awaitingResponse = false
        self.popCommandBufferQueue()
    }
    
    
    // MARK: - COMMANDS FUNCTIONS
    // USER COORDINATES
    func getLatitude(completionHandler: @escaping (Any) -> Void) {
        let com = GetLatitude()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    func getLongitude(completionHandler: @escaping (Any) -> Void) {
        let com = GetLongitude()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    // PARTNER 1
    func getPartner1Distance(completionHandler: @escaping (Any) -> Void) {
        let com = GetPartner1Distance()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    func getPartner1Address(completionHandler: @escaping (Any) -> Void) {
        let com = GetParter1Address()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    func getPartner1RSSI(completionHandler: @escaping (Any) -> Void) {
        let com = GetParter1RSSI()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    func getPartner1Heading(completionHandler: @escaping (Any) -> Void) {
        let com = GetParter1Heading()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    func sendMessagePartner1Message(completionHandler: @escaping (Any) -> Void) {
        let com = sendMessagePartner1()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    // PARTNER 2
    func getPartner2Distance(completionHandler: @escaping (Any) -> Void) {
        let com = GetPartner2Distance()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    func getPartner2Address(completionHandler: @escaping (Any) -> Void) {
        let com = GetParter2Address()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    func getPartner2RSSI(completionHandler: @escaping (Any) -> Void) {
        let com = GetParter2RSSI()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    
    func getPartner2Heading(completionHandler: @escaping (Any) -> Void) {
        let com = GetParter2Heading()
        executeCommand(command: com, completionHandler: completionHandler)
    }
    

}

