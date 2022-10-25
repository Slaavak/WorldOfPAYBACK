//
//  TransactionViewCell.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 25.10.22.
//

import UIKit

final class TransactionViewCell: UITableViewCell {

    @IBOutlet private weak var partnerNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

    private func setupUI() {

    }

    public func updateUI(with model: TransactionViewCellModel) {
        partnerNameLabel.text = model.partnerName
        descriptionLabel.text = model.description
        valueLabel.text = model.value + model.currency
        dateLabel.text = model.dateString
    }
}
