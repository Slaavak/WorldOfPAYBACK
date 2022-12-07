//
//  MainViewControllerProtoclos.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 6.12.22.
//

import Foundation

protocol MainViewControllerPresenterInput: AnyObject {
    func updateTableView(with models: [TransactionViewCellModel])
    func updatePicker(with models: [TransactionViewCellModel])
    func updateValueLabel(with text: String)
}

protocol MainViewControllerPresenterOutput: AnyObject {
    func startRequest()
    func handleGetTransactionsResponse(response: TransactionsEntityProtocol)
    func filterTransactions(with category: Int)
}
