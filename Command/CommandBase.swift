//
//  CommandBase.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/11/23.
//

import Foundation

protocol CommandBase {
    var txData: Data { get set }
    var responseValueConverter: ResponseConverter? {get set}
}

protocol ResponseConverter {
    func convertResponse(data: Data) -> Any
}

extension CommandBase {
    func convertResponseToValue(data: Data) -> Any {
        return (responseValueConverter?.convertResponse(data: data))
    }
}
