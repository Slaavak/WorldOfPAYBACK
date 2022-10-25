//
//  TransactionViewCellModel.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 25.10.22.
//

import Foundation

public class TransactionViewCellModel {

    init(
        partnerName: String,
        description: String,
        date: Date,
        dateString: String,
        value: String,
        currency: String
    ) {
        self.partnerName = partnerName
        self.description = description
        self.date = date
        self.value = value
        self.currency = currency
        self.dateString = dateString
    }

    public var partnerName: String
    public var description: String
    public var date: Date
    public var dateString: String
    public var value: String
    public var currency: String
}
