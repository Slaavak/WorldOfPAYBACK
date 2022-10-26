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
                print("We're connected!")
            } else {
                print("No connection.")
                // post disconnected notification
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Check your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
