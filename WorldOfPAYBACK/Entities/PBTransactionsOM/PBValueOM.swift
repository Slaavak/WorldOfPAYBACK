//
//  PBValueOM.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper

public class PBValueOM: MappableHelper {

    /// Описание
    public private(set) var amount: Int

    /// Дата бронирования
    public private(set) var currency: String

    required public init(map: Map) throws {
        amount = try map.value(Constants.amount)
        currency = try map.value(Constants.currency)

        try super.init(map: map)
    }

    public func mapping(map: Map) {
        super.mapping(map: map)

        amount <- map[Constants.amount]
        currency <- map[Constants.currency]
    }

    // MARK: - Constants

    private enum Constants {
        static let amount = "amount"
        static let currency = "currency"
    }
}

