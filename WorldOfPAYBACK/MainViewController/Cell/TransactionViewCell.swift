//
//  TransactionViewCell.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 25.10.22.
//

import UIKit

final class TransactionViewCell: UITableViewCell {

    @IBOutlet weak var partnerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!

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
