//
//  PBTransactionsOM.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper

public class PBTransactionsOM: MappableHelper, TransactionsEntityProtocol {

    /// Transactions
    public private(set) var items: [PBTransactionOM]

    public required init(map: Map) throws {
        items = try map.value(Constants.items)

        try super.init(map: map)
    }

    public func mapping(map: Map) {
        items <- (map[Constants.items], TransactionsArrayTransform())
    }

    // MARK: - Constants

    private enum Constants {
        static let items = "items"
    }
}

