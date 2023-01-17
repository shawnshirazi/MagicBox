//
//  IBLEManager.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/11/23.
//

import Foundation
import CoreBluetooth

protocol IBLEManager {
    
    var deviceDiscoveredHandler: ((ICommandExecutionService) -> Void)? {get set}
    
}
