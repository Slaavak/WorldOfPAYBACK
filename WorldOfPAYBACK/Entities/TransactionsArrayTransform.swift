//
//  TransactionsArrayTransform.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper

public class TransactionsArrayTransform: TransformType {

    public typealias Object = [PBTransactionOM]
    public typealias JSON = [[String: Any]]

    public func transformToJSON(_ value: Object?) -> JSON? {
        return value?.toJSON()
    }

    public func transformFromJSON(_ value: Any?) -> [PBTransactionOM]? {
        guard let value = value, let objects = value as? [PBTransactionOM] else {
            return nil
        }

        var result = [PBTransactionOM]()
        result.append(contentsOf: result.sorted(by: { $0.transactionDetail.bookingDate > $1.transactionDetail.bookingDate }))
        return result
    }
}
