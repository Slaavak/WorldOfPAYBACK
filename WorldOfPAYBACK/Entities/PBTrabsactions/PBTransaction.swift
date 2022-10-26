//
//  PBTransaction.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 27.10.22.
//

import Foundation

public struct PBTransaction: Codable {

    /// Имя
    public var partnerDisplayName: String

    /// Псевдоним
    public var alias: PBAlias

    /// Категория
    public var category: Int

    /// Детали транзакции
    public var transactionDetail: PBTransactionDetail
}
