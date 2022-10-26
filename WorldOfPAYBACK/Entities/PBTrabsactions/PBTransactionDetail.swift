//
//  PBTransactionDetail.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 27.10.22.
//

import Foundation

public struct PBTransactionDetail: Codable {

    /// Описание
    public var description: String?

    /// Дата бронирования
    public var bookingDate: String

    /// Стоимость
    public var value: PBValue
}


