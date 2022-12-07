//
//  TransactionDetailWireframe.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 7.12.22.
//

import UIKit

public final class TransactionDetailWireframe {
    // MARK: - Construction

    public init() {}

    // MARK: - Methods
    public func initTransactionDetailViewController() -> TransactionDetailViewController {
        if self.viewController == nil {
            let storyboard = UIStoryboard(
                name: Constants.storyboardIdentifier,
                bundle: nil
            )
            self.viewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerIdentifier) as? TransactionDetailViewController
            configurator.configureViewInput(viewInput: viewController)
        }
        return viewController!
    }

// MARK: - Constants

    private enum Constants {
        static let viewControllerIdentifier = "TransactionDetailViewController"
        static let storyboardIdentifier = "TransactionDetailViewController"
    }

// MARK: - Variables

    private weak var viewController: TransactionDetailViewController?
    private let configurator = TransactionDetailConfigurator()
}
