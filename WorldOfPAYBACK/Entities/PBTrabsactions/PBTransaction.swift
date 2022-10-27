//
//  PBTransaction.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 27.10.22.
//

import Foundation

public struct PBTransaction: Codable {

    /// Partnetr name
    public var partnerDisplayName: String

    /// Alias
    public var alias: PBAlias

    /// Category
    public var category: Int

    /// Transaction details
    public var transactionDetail: PBTransactionDetail
}
