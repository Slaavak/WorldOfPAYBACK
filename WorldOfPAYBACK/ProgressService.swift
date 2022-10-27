//
//  ProgressService.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 27.10.22.
//

import UIKit

public protocol ProgressServiceProtocol {
    func showLoader()
    func hideLoader(complition: VoidBlock?)
    func showErrorAlert(message: String)
}

public class ProgressService: ProgressServiceProtocol {

    private var viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func showLoader() {
            let storyboard = UIStoryboard.init(name: Constants.loaderViewIdentifier, bundle: nil)
            let loader = storyboard.instantiateViewController(withIdentifier: Constants.loaderViewIdentifier)
            loader.modalPresentationStyle = .overFullScreen

        DispatchQueue.performOnMainThread {
            viewController.present(loader, animated: false)
        }
    }

    public func hideLoader(complition: VoidBlock? = nil) {
        DispatchQueue.performOnMainThread {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            viewController.dismiss(animated: false, completion: {
                dispatchGroup.leave()
            })
            dispatchGroup.notify(queue: .main, execute: {
                complition?()
            })
        }
    }

    public func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: Constants.failureAlertTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: Constants.failureAlertOk,
                style: .default,
                handler: nil
            )
        )
        viewController.present(alert, animated: true)
    }

    private enum Constants {
        static let loaderViewIdentifier = "LoaderView"
        static let failureAlertTitle = "Error"
        static let failureAlertOk = "Ok"
    }
}
