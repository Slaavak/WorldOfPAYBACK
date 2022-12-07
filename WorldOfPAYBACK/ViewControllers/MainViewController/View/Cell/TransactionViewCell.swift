//
//  TransactionViewCell.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 25.10.22.
//

import UIKit

final public class TransactionViewCell: UITableViewCell {

    //MARK: - Outlets

    @IBOutlet private weak var decorView: UIView!
    @IBOutlet private weak var partnerNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    //MARK: - Lyfecycle

    public override func awakeFromNib() {
        super.awakeFromNib()

        decorView.backgroundColor = .random
        backgroundColor = Constants.backgroundColor
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true
    }

    //MARK: - Actions

    public func updateUI(with model: TransactionViewCellModel) {
        partnerNameLabel.text = model.partnerName
        descriptionLabel.text = model.description
        valueLabel.text = String(model.amount) +  model.currency
        dateLabel.text = model.dateString
    }

    //MARK: - Constants

    private enum Constants {
        static let backgroundColor = UIColor(
            red: 0.85,
            green: 0.85,
            blue: 0.85,
            alpha: 1
        )
    }
}
