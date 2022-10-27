//
//  NetworkMonitor.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 26.10.22.
//

import Network
import UIKit

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print(Constants.connectionPrint)
            } else {
                print(Constants.disconnectionPrint)
                let alert = UIAlertController(
                    title: Constants.alertTitle,
                    message: Constants.alertMessage,
                    preferredStyle: .alert
                )
                alert.addAction(
                    UIAlertAction(
                        title: Constants.alertOk,
                        style: .default,
                        handler: nil
                    )
                )
                DispatchQueue.performOnMainThread {
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: Constants.dispatchQueueLabel)
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    //MARK: - Constatns

    private enum Constants {
        static let dispatchQueueLabel = "NetworkMonitor"
        static let alertTitle = "Error"
        static let alertMessage = "Check your internet connection"
        static let alertOk = "Ok"
        static let connectionPrint = "Connected!"
        static let disconnectionPrint = "No connection."
    }
}
