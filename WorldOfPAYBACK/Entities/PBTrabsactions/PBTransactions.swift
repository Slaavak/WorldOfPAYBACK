//
//  PBTransactions.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 25.10.22.
//

import Foundation

public struct PBTransactions: Codable, TransactionsEntityProtocol {
    
    /// Transactions
    public var items: [PBTransaction]
}
