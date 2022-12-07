//
//  TransactionDetailViewController.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 26.10.22.
//

import UIKit

public final class TransactionDetailViewController: UIViewController {

    //MARK: - Outlets

    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var titleNameLabel: UILabel!

    //MARK: - Properties

    public var item: TransactionViewCellModel!
    var output: TransactionDetailPresenterOutput!

    //MARK: - Lyfecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = item.description
        titleNameLabel.text = item.partnerName
    }
}

// MARK: - TransactionDetailPresenterInput

extension TransactionDetailViewController: TransactionDetailPresenterInput {
}
