//
//  GetCommands.swift
//  MagicBoxV2
//
//  Created by Shawn Shirazi on 1/11/23.
//

import Foundation

// MARK: - RESPONSE CONVERSIONS

struct ResponseHexToString: ResponseConverter {
    func convertResponse(data: Data) -> Any {
        let response = String(decoding: data, as: UTF8.self)
        return response
    }
}

struct ResponseHexToDouble: ResponseConverter {
    func convertResponse(data: Data) -> Any {
        let str = String(decoding: data, as: UTF8.self)
        let reponse = Double(str)
        return reponse
    }
}

// MARK: - USER COORDINATES

struct GetLatitude: CommandBase {
    var txData: Data = Data("0".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToString()
}

struct GetLongitude: CommandBase {
    var txData: Data = Data("1".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToString()
}


// MARK: - PARTNER 1

struct GetPartner1Distance: CommandBase {
    var txData: Data = Data("4 1".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToString()
}

struct GetParter1Address: CommandBase {
    var txData: Data = Data("A 1".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToString()
}

struct GetParter1RSSI: CommandBase {
    var txData: Data = Data("6 1".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToString()
}

struct GetParter1Heading: CommandBase {
    var txData: Data = Data("5 1".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToDouble()
}

struct sendMessagePartner1: CommandBase {
    var txData: Data = Data("9 1".utf8)
    var responseValueConverter: ResponseConverter?
}


// MARK: - PARTNER 2

struct GetPartner2Distance: CommandBase {
    var txData: Data = Data("4 2".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToString()
}

struct GetParter2Address: CommandBase {
    var txData: Data = Data("A 2".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToString()
}

struct GetParter2RSSI: CommandBase {
    var txData: Data = Data("6 2".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToString()
}

struct GetParter2Heading: CommandBase {
    var txData: Data = Data("5 2".utf8)
    var responseValueConverter: ResponseConverter? = ResponseHexToDouble()
}

struct sendMessagePartner2: CommandBase {
    var txData: Data = Data("9 2".utf8)
    var responseValueConverter: ResponseConverter?
}
