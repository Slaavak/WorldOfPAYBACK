//
//  TransactionDetailConfigurator.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 7.12.22.
//

import Foundation

public final class TransactionDetailConfigurator {
    func configureViewInput<UIViewController>(viewInput: UIViewController) {
        if let viewController = viewInput as? TransactionDetailViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: TransactionDetailViewController) {

        let presenter = TransactionDetailPresenter()
        presenter.view = viewController
        viewController.output = presenter
    }
}
