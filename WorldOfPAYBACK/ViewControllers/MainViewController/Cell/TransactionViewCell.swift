//
//  TransactionViewCell.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 25.10.22.
//

import UIKit

class TransactionViewCell: UITableViewCell {

    //MARK: - Outlets

    @IBOutlet private weak var partnerNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    //MARK: - Lyfecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Actions

    public func updateUI(with model: TransactionViewCellModel) {
        partnerNameLabel.text = model.partnerName
        descriptionLabel.text = model.description
        valueLabel.text = String(model.amount) + model.currency
        dateLabel.text = model.dateString
    }
}
