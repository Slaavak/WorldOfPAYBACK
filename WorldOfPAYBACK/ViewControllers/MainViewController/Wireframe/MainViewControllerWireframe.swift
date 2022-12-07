//
//  MainViewControllerWireframe.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 6.12.22.
//

import UIKit

public final class MainViewControllerWireframe {

    // MARK: - Construction

    public init() {}

    // MARK: - Methods

    public func initMainViewControllerViewController() -> MainViewController {
        if self.viewController == nil {
            let storyboard = UIStoryboard(
                name: Constants.storyboardIdentifier,
                bundle: nil
            )
            self.viewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerIdentifier) as? MainViewController
            configurator.configureViewInput(viewInput: viewController)
        }
        return viewController!
    }

// MARK: - Constants

    private enum Constants {
        static let viewControllerIdentifier = "ViewController"
        static let storyboardIdentifier = "Main"
    }

// MARK: - Variables

    private weak var viewController: MainViewController?
    private let configurator = MainViewCotrollerConfigurator()
}
