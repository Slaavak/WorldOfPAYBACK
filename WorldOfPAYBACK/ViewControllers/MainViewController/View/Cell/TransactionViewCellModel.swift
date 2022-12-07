//
//  TransactionViewCellModel.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 25.10.22.
//

import Foundation

public final class TransactionViewCellModel {

    //MARK: - Init

    init(
        partnerName: String,
        description: String,
        date: Date,
        dateString: String,
        amount: Int,
        currency: String,
        category: Int
    ) {
        self.partnerName = partnerName
        self.description = description
        self.date = date
        self.amount = amount
        self.currency = currency
        self.dateString = dateString
        self.category = category
    }

    //MARK: - Properties

    public let partnerName: String
    public let description: String
    public let date: Date
    public let dateString: String
    public let amount: Int
    public let currency: String
    public let category: Int
}
