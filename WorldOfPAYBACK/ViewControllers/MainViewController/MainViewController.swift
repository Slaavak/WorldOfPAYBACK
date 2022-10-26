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
    @IBOutlet private weak var bottomButtonOutlet: UIButton!

    //MARK: - Properties

    private var networkHelper: NetworkHelperProtocol!
    private var cellReuseIdentifier = "TransactionViewCell"
    private var transactionCellViewModels: [TransactionViewCellModel] = []
    private var transactionCellViewModelsToDisplay: [TransactionViewCellModel] = []
    private var transactionsCategory = ["All", "Sell", "Buy", "Special"]
    private var pickerView = UIPickerView()

    //MARK: - Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitoring()
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
                let alert = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                weakSelf?.present(alert, animated: true, completion: nil)
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
        networkHelper = NetworkHelperMocked()
#else
        networkHelper = NetworkHelper()
#endif


        pickerView.dataSource = self
        pickerView.delegate = self
        pickerViewTextField.text = transactionsCategory.first ?? .empty
        pickerViewTextField.delegate = self
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
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: cellReuseIdentifier, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }

    private func formatDate(string: String) -> (Date, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let resultString = dateFormatter.string(from: date)

        return (date, resultString)
    }

    private func showLoaderView() {
        let loader = UIStoryboard.init(name: "LoaderView", bundle: nil).instantiateViewController(withIdentifier: "LoaderView")
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
        transactionsValueAmountLabel.text = "Total: " + String(totalAmount)
    }

    private func pickerViewValueDidChanged(category: Int) {
        filterTransactions(category: category)
        changeLabelText(category: category)
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = UIStoryboard.init(name: "TransactionDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "TransactionDetailViewController") as? TransactionDetailViewController {
            vc.item = transactionCellViewModelsToDisplay[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionCellViewModelsToDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? TransactionViewCell else {
            return UITableViewCell()
        }

        cell.updateUI(with: transactionCellViewModelsToDisplay[indexPath.row])
        return cell
    }
}






extension MainViewController: UITextFieldDelegate {

}

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
