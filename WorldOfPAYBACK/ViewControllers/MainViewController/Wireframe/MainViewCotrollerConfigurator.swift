//
//  MainViewCotrollerConfigurator.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 6.12.22.
//

import Foundation

public final class MainViewCotrollerConfigurator {
    func configureViewInput<UIViewController>(viewInput: UIViewController) {
        if let viewController = viewInput as? MainViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: MainViewController) {
        let networkHelper: NetworkHelperProtocol
#if DEBUG
        networkHelper = NetworkServiceMocked()
#else
        networkHelper = NetworkService()
#endif

        let progressService = ProgressService(viewController: viewController)

        let presenter = MainViewControllerPresenter()
        presenter.networkHelper = networkHelper
        presenter.view = viewController
        presenter.progressService = progressService

        viewController.output = presenter
    }
}
