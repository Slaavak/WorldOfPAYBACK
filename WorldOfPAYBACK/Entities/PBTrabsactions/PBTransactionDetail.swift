//
//  PBTransactionDetail.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 27.10.22.
//

import Foundation

public struct PBTransactionDetail: Codable {

    /// Description
    public var description: String?

    /// Booking date
    public var bookingDate: String

    /// Value
    public var value: PBValue
}


