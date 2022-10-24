//
//  PBTransactionsOM.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper

public class PBTransactionsOM: Mappable {

    /// Транзакции
    public private(set) var items: [Transaction]

    required public init(map: Map) throws {
        items = try map.value(Constants.items)

        try super.init(map: map)
    }

    override public func mapping(map: Map) {
        super.mapping(map: map)

        items <- map([Constants.items], TransactionsArrayTransform())
    }

    // MARK: - Constants

    private enum Constants {
        static let items = "items"
    }
}

