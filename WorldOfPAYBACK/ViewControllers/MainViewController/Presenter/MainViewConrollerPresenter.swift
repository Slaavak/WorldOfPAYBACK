//
//  MainViewConrollerPresenter.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 6.12.22.
//

import Foundation


final class MainViewControllerPresenter: MainViewControllerPresenterOutput {

    //MARK: - Properties

    weak var view: MainViewControllerPresenterInput!
    var networkHelper: NetworkHelperProtocol!
    var progressService: ProgressServiceProtocol!
    private var transactionCellViewModels: [TransactionViewCellModel] = []

    //MARK: - Init

    init() {}

    //MARK: - Ations

    public func startRequest() {
        weak var weakSelf = self
        networkHelper.getTransactions(
            success: { response in
                guard let strongSelf = weakSelf else {
                    return
                }

                strongSelf.handleGetTransactionsResponse(response: response)
                strongSelf.progressService.hideLoader(complition: nil)
            },
            failure: { errorMsg in
                DispatchQueue.performOnMainThread({
                    weakSelf?.progressService.hideLoader(complition: {
                        weakSelf?.progressService.showErrorAlert(message: errorMsg)
                    })
                })
            },
            initInterface: {
                weakSelf?.progressService.showLoader()
            }
        )
    }

    public func handleGetTransactionsResponse(response: TransactionsEntityProtocol) {
#if DEBUG
        parseGetTransactionsResponse(response: response)
#else
        parseGetTransactionsResponseOM(response: response)
#endif
    }

    public func filterTransactions(with category: Int) {
        if category == .zero {
            view.updateTableView(with: transactionCellViewModels)
            view.updateValueLabel(with: .empty)
        } else {
            var totalAmount: Int = .zero
            let cellViewModels = transactionCellViewModels.filter({ $0.category == category })
            cellViewModels.forEach({ totalAmount += $0.amount })
            view.updatePicker(with: cellViewModels)
            view.updateValueLabel(with: Constants.transactionsValueAmountLabelText + String(totalAmount))
        }
    }

    //MARK: - Privat actions

    private func parseGetTransactionsResponse(response: TransactionsEntityProtocol) {
        guard let resp = response as? PBTransactions else {
            return
        }
        transactionCellViewModels = []
        for item in resp.items {
            let dateTuple = formatDate(string: item.transactionDetail.bookingDate)
            transactionCellViewModels.append(
                TransactionViewCellModel(
                    partnerName: item.partnerDisplayName,
                    description: item.transactionDetail.description ?? .emptySpace,
                    date: dateTuple.0 ?? Date.distantPast,
                    dateString: dateTuple.1 ?? .emptySpace,
                    amount: item.transactionDetail.value.amount,
                    currency: item.transactionDetail.value.currency,
                    category: item.category
                )
            )
        }
        transactionCellViewModels = transactionCellViewModels.sorted(by: { $0.date > $1.date })
        view.updateTableView(with: transactionCellViewModels)
    }

    private func parseGetTransactionsResponseOM(response: TransactionsEntityProtocol) {
        guard let resp = response as? PBTransactionsOM  else {
            return
        }
        transactionCellViewModels = []
        for item in resp.items {
            let dateTuple = formatDate(string: item.transactionDetail.bookingDate)
            transactionCellViewModels.append(
                TransactionViewCellModel(
                    partnerName: item.partnerDisplayName,
                    description: item.transactionDetail.description ?? .emptySpace,
                    date: dateTuple.0 ?? Date.distantPast,
                    dateString: dateTuple.1 ?? .emptySpace,
                    amount: item.transactionDetail.value.amount,
                    currency: item.transactionDetail.value.currency,
                    category: item.category
                )
            )
        }
        transactionCellViewModels = transactionCellViewModels.sorted(by: { $0.date > $1.date })
        view.updateTableView(with: transactionCellViewModels)
    }

    private func formatDate(string: String) -> (Date?, String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.responseDateFormat

        guard let date = dateFormatter.date(from: string) else {
            return (nil, nil)
        }
        dateFormatter.dateFormat = Constants.dateFormat
        let resultString = dateFormatter.string(from: date)

        return (date, resultString)
    }

    // MARK: - Constants

    private enum Constants {
        static let dateFormat = "dd.MM.yyyy"
        static let responseDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let transactionsValueAmountLabelText = "Total: "
    }
}
