//
//  NetworkHelper.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import Foundation

protocol NetworkHelperProtocol {
    func getTransactions()
}

class NetworkHelper: NetworkHelperProtocol {

    private func d() {

    }

    func getTransactions() {
        d()
        let session = URLSession(configuration: .default)
        let url = URL(fileURLWithPath: "https://api-test.payback.com/transactions")
        let dataTask = session.dataTask(with: url) { data, response, error in

        }
    }
}
