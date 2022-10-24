//
//  PBTransactionOM.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper

public class PBTransactionOM: MappableHelper {

    /// Имя
    public private(set) var partnerDisplayName: String

    /// Псевдоним
    public private(set) var alias: [PBAliasOM]

    /// Категория
    public private(set) var category: Int

    /// Детали транзакции
    public private(set) var transactionDetail: [PBTransactionDetailOM]

    required public init(map: Map) throws {
        partnerDisplayName = try map.value(Constants.partnerDisplayName)
        alias = try map.value(Constants.alias)
        category = try map.value(Constants.category)
        transactionDetail = try map.value(Constants.transactionDetail)

        try super.init(map: map)
    }

    public func mapping(map: Map) {
        super.mapping(map: map)

        partnerDisplayName <- map[Constants.partnerDisplayName]
        alias <- map[Constants.alias]
        category <- map[Constants.category]
        transactionDetail <- map[Constants.transactionDetail]
    }

    // MARK: - Constants

    private enum Constants {
        static let partnerDisplayName = "partnerDisplayName"
        static let alias = "alias"
        static let category = "category"
        static let transactionDetail = "transactionDetail"
    }
}
