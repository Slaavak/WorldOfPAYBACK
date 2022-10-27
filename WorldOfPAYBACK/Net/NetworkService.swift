//
//  NetworkService.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import ObjectMapper
import Foundation

protocol NetworkHelperProtocol {
    func getTransactions(
        success: @escaping (TransactionsEntityProtocol) -> Void,
        failure: @escaping ((String) -> Void),
        initInterface: @escaping (VoidBlock)
    )
}

class NetworkService: NetworkHelperProtocol {

    func getTransactions(
        success: @escaping (TransactionsEntityProtocol) -> Void,
        failure: @escaping ((String) -> Void),
        initInterface: @escaping (VoidBlock)
    ) {

        initInterface()
        DispatchQueue.global().async {
            let session = URLSession(configuration: .default)
            let url = URL(fileURLWithPath: "https://api.payback.com/transactions")
            let dataTask = session.dataTask(with: url) { data, response, error in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let object = Mapper<PBTransactionsOM>().map(JSON: json) else {
                    failure(error?.localizedDescription ?? .empty)
                    return
                }
                
                DispatchQueue.performOnMainThread {
                    success(object)
                }
            }
            dataTask.resume()
        }
    }
}
