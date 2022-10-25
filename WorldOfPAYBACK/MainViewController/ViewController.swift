//
//  ViewController.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Outlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomButtonOutlet: UIButton!

    //MARK: - Properties

    private var networkHelper: NetworkHelperProtocol!
    private var cellReuseIdentifier = "TransactionViewCell"
    private var transactionCellViewModels: [TransactionViewCellModel] = []

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
                weakSelf?.showSpinnerView()
            },
            finalizeInterface: {
                weakSelf?.hideSpinnerView()
            }
        )
    }

    private func setup() {
        networkHelper = NetworkHelper()
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
                    description: item.transactionDetail.description ?? " ",
                    date: dateTuple.0,
                    dateString: dateTuple.1,
                    value: String(item.transactionDetail.value.amount),
                    currency: item.transactionDetail.value.currency
                )
            )
        }
        transactionCellViewModels = transactionCellViewModels.sorted(by: { $0.date > $1.date })
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
                    value: String(item.transactionDetail.value.amount),
                    currency: item.transactionDetail.value.currency
                )
            )
        }
        transactionCellViewModels = transactionCellViewModels.sorted(by: { $0.date > $1.date })
        tableView.reloadData()
#endif
    }

    private func setupTableView() {
        //        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemYellow
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

    private func showSpinnerView() {
        let loader = UIStoryboard.init(name: "LoaderView", bundle: nil).instantiateViewController(withIdentifier: "LoaderView")
        loader.modalPresentationStyle = .overFullScreen

        present(loader, animated: false, completion: nil)
    }

    private func hideSpinnerView() {
        dismiss(animated: false, completion: nil)
    }
}

//MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? TransactionViewCell else {
            return UITableViewCell()
        }

        cell.updateUI(with: transactionCellViewModels[indexPath.row])
        return cell
    }
}







class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func loadView() {
//        view = UIView()
//        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
//
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        spinner.startAnimating()
//        view.addSubview(spinner)
//
//        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true


    }
}
