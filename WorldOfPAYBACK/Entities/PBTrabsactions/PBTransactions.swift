//
//  PBTransactions.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 25.10.22.
//

import Foundation

protocol TransactionsEntityProtocol {}

public struct PBTransactions: Codable, TransactionsEntityProtocol {
    
    /// Транзакции
    public var items: [PBTransaction]
}



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



public struct PBAlias: Codable {

    /// Ссылка
    public var reference: String
}



public struct PBTransactionDetail: Codable {

    /// Описание
    public var description: String?

    /// Дата бронирования
    public var bookingDate: String

    /// Стоимость
    public var value: PBValue
}



public struct PBValue: Codable {

    /// Описание
    public var amount: Int

    /// Дата бронирования
    public var currency: String
}
