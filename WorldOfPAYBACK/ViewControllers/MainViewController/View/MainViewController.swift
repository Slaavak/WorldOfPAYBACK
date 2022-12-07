//
//  MainViewController.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import UIKit

public final class MainViewController: UIViewController {

    //MARK: - Outlets

    @IBOutlet private weak var pickerViewTextField: UITextField!
    @IBOutlet private weak var transactionsValueAmountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var bottomButtonOutlet: UIButton!

    //MARK: - Properties

    private var transactionCellViewModelsToDisplay: [TransactionViewCellModel] = []
    private var transactionsCategory = ["All", "Sell", "Buy", "Special"]
    private var pickerView = UIPickerView()

    var output: MainViewControllerPresenterOutput!

    //MARK: - Lyfecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        output.startRequest()
    }

    //MARK: - Actions

    @IBAction func didTapBottomButton(_ sender: UIButton) {
        output.startRequest()
        pickerView.selectRow(.zero, inComponent: .zero, animated: false)
        pickerViewTextField.text = transactionsCategory.first ?? .empty
        transactionsValueAmountLabel.text = .empty
    }

    //MARK: - Private funcs

    private func setup() {
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
        output.handleGetTransactionsResponse(response: response)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Constants.cellReuseIdentifier,bundle: nil), forCellReuseIdentifier: Constants.cellReuseIdentifier)
    }

    private func pickerViewValueDidChanged(category: Int) {
        if category == .zero {
            transactionsValueAmountLabel.text = .empty
        }
        output.filterTransactions(with: category)
    }

    // MARK: - Constants

    private enum Constants {
        static let rowHeight: CGFloat = 50
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

    public func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard.init(name: Constants.transactionDetailIdentifier, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: Constants.transactionDetailIdentifier) as? TransactionDetailViewController {
            vc.item = transactionCellViewModelsToDisplay[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionCellViewModelsToDisplay.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) as? TransactionViewCell else {
            return UITableViewCell()
        }

        cell.updateUI(with: transactionCellViewModelsToDisplay[indexPath.row])
        return cell
    }
}


// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension MainViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.numberOfComponents
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return transactionsCategory.count
    }

    public func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return transactionsCategory[row]
    }

    public func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewTextField.text = transactionsCategory[row]
        pickerViewTextField.resignFirstResponder()
        pickerViewValueDidChanged(category: row)
    }
}

// MARK: - MainViewControllerPresenterInput

extension MainViewController: MainViewControllerPresenterInput {

    public func updateTableView(with models: [TransactionViewCellModel]) {
        transactionCellViewModelsToDisplay = models
        tableView.reloadData()
    }

    public func updatePicker(with models: [TransactionViewCellModel]) {
        transactionCellViewModelsToDisplay = models
        tableView.reloadData()
    }

    public func updateValueLabel(with text: String) {
        transactionsValueAmountLabel.text = text
    }
}
