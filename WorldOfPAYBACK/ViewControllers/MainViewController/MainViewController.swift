//
//  MainViewController.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import UIKit

class MainViewController: UIViewController {

    //MARK: - Outlets

    @IBOutlet private weak var pickerViewTextField: UITextField!
    @IBOutlet private weak var transactionsValueAmountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var bottomButtonOutlet: UIButton!

    //MARK: - Properties

    private var networkHelper: NetworkHelperProtocol!
    private var transactionCellViewModels: [TransactionViewCellModel] = []
    private var transactionCellViewModelsToDisplay: [TransactionViewCellModel] = []
    private var transactionsCategory = ["All", "Sell", "Buy", "Special"]
    private var pickerView = UIPickerView()

    //MARK: - Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        startRequest()
    }

    //MARK: - Actions

    @IBAction func didTapBottomButton(_ sender: UIButton) {
        startRequest()
        pickerView.selectRow(.zero, inComponent: .zero, animated: false)
        pickerViewTextField.text = transactionsCategory.first ?? .empty
        transactionsValueAmountLabel.text = .empty
    }

    //MARK: - Private funcs

    private func startRequest() {
        weak var weakSelf = self
        networkHelper.getTransactions(
            success: { response in
                guard let strongSelf = weakSelf else {
                    return
                }

                strongSelf.handleGetTransactionsResponse(response: response)
            },
            failure: { errorMsg in
                let alert = UIAlertController(
                    title: Constants.failureAlertTitle,
                    message: errorMsg,
                    preferredStyle: .alert
                )
                alert.addAction(
                    UIAlertAction(
                        title: Constants.failureAlertOk,
                        style: .default,
                        handler: nil
                    )
                )
                weakSelf?.present(alert, animated: true)
            },
            initInterface: {
                weakSelf?.showLoaderView()
            },
            finalizeInterface: {
                weakSelf?.hideLoaderView()
            }
        )
    }

    private func setup() {
#if DEBUG
        networkHelper = NetworkServiceMocked()
#else
        networkHelper = NetworkService()
#endif
        bottomButtonOutlet.layer.cornerRadius = 10
        bottomButtonOutlet.layer.masksToBounds = true
        title = Constants.viewControllerTitle
        headerView.backgroundColor = Constants.headerBackgroundColor
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerViewTextField.text = transactionsCategory.first ?? .empty
        pickerViewTextField.inputView = pickerView
        view.backgroundColor = .white
    }

    private func handleGetTransactionsResponse(response: TransactionsEntityProtocol) {
#if DEBUG
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
                    date: dateTuple.0,
                    dateString: dateTuple.1,
                    amount: item.transactionDetail.value.amount,
                    currency: item.transactionDetail.value.currency,
                    category: item.category
                )
            )
        }
        transactionCellViewModels = transactionCellViewModels.sorted(by: { $0.date > $1.date })
        transactionCellViewModelsToDisplay = transactionCellViewModels
        tableView.reloadData()
#else
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
                    date: dateTuple.0,
                    dateString: dateTuple.1,
                    amount: item.transactionDetail.value.amount,
                    currency: item.transactionDetail.value.currency,
                    category: item.category
                )
            )
        }
        transactionCellViewModels = transactionCellViewModels.sorted(by: { $0.date > $1.date })
        transactionCellViewModelsToDisplay = transactionCellViewModels
        tableView.reloadData()
#endif
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Constants.cellReuseIdentifier,bundle: nil), forCellReuseIdentifier: Constants.cellReuseIdentifier)
    }

    private func formatDate(string: String) -> (Date, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.responseDateFormat
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = Constants.dateFormat
        let resultString = dateFormatter.string(from: date)

        return (date, resultString)
    }

    private func showLoaderView() {
        let storyboard = UIStoryboard.init(name: Constants.loaderViewIdentifier, bundle: nil)
        let loader = storyboard.instantiateViewController(withIdentifier: Constants.loaderViewIdentifier)
        loader.modalPresentationStyle = .overFullScreen

        present(loader, animated: false, completion: nil)
    }

    private func hideLoaderView() {
        dismiss(animated: false, completion: nil)
    }

    private func filterTransactions(category: Int) {
        if category == .zero {
            transactionsValueAmountLabel.text = .empty
            transactionCellViewModelsToDisplay = transactionCellViewModels
            tableView.reloadData()
        } else {
            transactionCellViewModelsToDisplay = transactionCellViewModels.filter({ $0.category == category })
            tableView.reloadData()
        }
    }

    private func changeLabelText(category: Int) {
        // It is not clear from the technical task what to do if we have transactions with different currencies
        var totalAmount: Int = .zero
        transactionCellViewModelsToDisplay.forEach({ totalAmount += $0.amount })
        transactionsValueAmountLabel.text = Constants.transactionsValueAmountLabelText + String(totalAmount)
    }

    private func pickerViewValueDidChanged(category: Int) {
        filterTransactions(category: category)
        changeLabelText(category: category)
    }

    // MARK: - Constants

    private enum Constants {
        static let transactionsValueAmountLabelText = "Total: "
        static let loaderViewIdentifier = "LoaderView"
        static let dateFormat = "dd.MM.yyyy"
        static let responseDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let rowHeight: CGFloat = 50
        static let failureAlertTitle = "Error"
        static let failureAlertOk = "Ok"
        static let cellReuseIdentifier = "TransactionViewCell"
        static let transactionDetailIdentifier = "TransactionDetailViewController"
        static let numberOfSections = 1
        static let numberOfComponents = 1
        static let viewControllerTitle = "Transactions"
        static let headerBackgroundColor = UIColor(
            red: 0.85,
            green: 0.85,
            blue: 0.85,
            alpha: 1
        )
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: Constants.transactionDetailIdentifier, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: Constants.transactionDetailIdentifier) as? TransactionDetailViewController {
            vc.item = transactionCellViewModelsToDisplay[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionCellViewModelsToDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) as? TransactionViewCell else {
            return UITableViewCell()
        }

        cell.updateUI(with: transactionCellViewModelsToDisplay[indexPath.row])
        return cell
    }
}


// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.numberOfComponents
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return transactionsCategory.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return transactionsCategory[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewTextField.text = transactionsCategory[row]
        pickerViewTextField.resignFirstResponder()
        pickerViewValueDidChanged(category: row)
    }
}
