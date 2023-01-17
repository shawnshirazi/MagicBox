//
//  ICommandExecutionService.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/11/23.
//

import Foundation
import CoreBluetooth

protocol ICommandExecutionService {
    
    var communicationPeripheral: CBPeripheral? { get }
    func resetPeripheral()
    var deviceDisconnected: (() -> Void)? { get set}
//    var getLatitude(completionHandler: @escaping (Any) ->void)
}
