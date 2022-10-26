//
//  TransactionDetailViewController.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 26.10.22.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleNameLabel: UILabel!

    public var item: TransactionViewCellModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = item.description
        titleNameLabel.text = item.partnerName
    }


}
