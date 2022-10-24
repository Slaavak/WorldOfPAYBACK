//
//  NetworkHelper.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper
import Foundation

protocol NetworkHelperProtocol {
    func getTransactions(
        success: @escaping (PBTransactionsOM) -> Void,
        failure: @escaping (() -> Void),
        initInterface: @escaping (() -> Void),
        finalizeInterface: @escaping (() -> Void)
    )
}

class NetworkHelper: NetworkHelperProtocol {

    private func d() {

    }

    func getTransactions(
        success: @escaping (PBTransactionsOM) -> Void,
        failure: @escaping (() -> Void),
        initInterface: @escaping (() -> Void),
        finalizeInterface: @escaping (() -> Void)
    ) {
        d()

        initInterface()
        DispatchQueue.global().async {
            let session = URLSession(configuration: .default)
            let url = URL(fileURLWithPath: "https://api-test.payback.com/transactions")
            let dataTask = session.dataTask(with: url) { data, response, error in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let object = Mapper<PBTransactionsOM>().map(JSON: json) else {
                          DispatchQueue.main.async {
                              failure()
                              finalizeInterface()
                          }
                          return
                      }

                DispatchQueue.main.async {
                    success(object)
                    finalizeInterface()
                }
            }
            dataTask.resume()
        }
    }
}
