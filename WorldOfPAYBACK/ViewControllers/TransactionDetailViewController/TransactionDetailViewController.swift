//
//  TransactionDetailViewController.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 26.10.22.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    //MARK: - Outlets

    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var titleNameLabel: UILabel!

    //MARK: - Properties

    public var item: TransactionViewCellModel!

    //MARK: - Lyfecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = item.description
        titleNameLabel.text = item.partnerName
    }
}
