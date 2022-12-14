//
//  PBTransactionDetailOM.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper

public class PBTransactionDetailOM: MappableHelper {

    /// Description
    public private(set) var description: String?

    /// Booking date
    public private(set) var bookingDate: String

    /// Value
    public private(set) var value: PBValueOM

    required public init(map: Map) throws {
        description = try map.value(Constants.description)
        bookingDate = try map.value(Constants.bookingDate)
        value = try map.value(Constants.value)

        try super.init(map: map)
    }

    public func mapping(map: Map) {
        super.mapping(map: map)

        description <- map[Constants.description]
        bookingDate <- map[Constants.bookingDate]
        value <- map[Constants.value]
    }

    // MARK: - Constants

    private enum Constants {
        static let description = "description"
        static let bookingDate = "bookingDate"
        static let value = "value"
    }
}
