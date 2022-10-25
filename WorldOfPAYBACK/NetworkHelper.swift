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
        success: @escaping (TransactionsEntityProtocol) -> Void,
        failure: @escaping ((String) -> Void),
        initInterface: @escaping (() -> Void),
        finalizeInterface: @escaping (() -> Void)
    )
}

class NetworkHelper: NetworkHelperProtocol {

    private var delaySimulation: DispatchTime = .now()

    init() {
#if DEBUG
        delaySimulation = .now() + 2
#endif
    }

    func getTransactions(
        success: @escaping (TransactionsEntityProtocol) -> Void,
        failure: @escaping ((String) -> Void),
        initInterface: @escaping (() -> Void),
        finalizeInterface: @escaping (() -> Void)
    ) {

#if DEBUG
        initInterface()
        DispatchQueue.global().asyncAfter(deadline: delaySimulation) {
            /*
             Based on the condition of the technical task, it is not clear:
              --  I want to see a list of (mocked) transactions. Just assume that the Backend is not ready yet and the App needs to work with mocked data meanwhile.
              --  For now, the Backend-Team has just provided the name of the endpoints for the new Service:
                            Production Environment: "GET https://api.payback.com/transactions"
                            Test Environment: "GET https://api-test.payback.com/transactions"
             */
            if let url = Bundle.main.url(forResource: "PBTransactions", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(PBTransactions.self, from: data)
                    DispatchQueue.main.async {
                        success(jsonData)
                        finalizeInterface()
                    }
                } catch {
                    DispatchQueue.main.async {
                        failure("error:\(error)")
                        finalizeInterface()
                    }
                }
            }
        }

#else
        initInterface()
        DispatchQueue.global().asyncAfter(deadline: delaySimulation) {
            let session = URLSession(configuration: .default)
            let url = URL(fileURLWithPath: "https://api.payback.com/transactions")
            let dataTask = session.dataTask(with: url) { data, response, error in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let object = Mapper<PBTransactionsOM>().map(JSON: json) else {
                          DispatchQueue.main.async {
                              failure(error?.localizedDescription ?? .empty)
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
#endif

    }
}
