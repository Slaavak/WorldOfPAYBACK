//
//  NetworkHelperMocked.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 26.10.22.
//

import Foundation

class NetworkHelperMocked: NetworkHelperProtocol {

    private var delaySimulation: DispatchTime = .now() + 3

    func getTransactions(
        success: @escaping (TransactionsEntityProtocol) -> Void,
        failure: @escaping ((String) -> Void),
        initInterface: @escaping (() -> Void),
        finalizeInterface: @escaping (() -> Void)
    ) {
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
                        finalizeInterface()
                        failure("error:\(error)")
                    }
                }
            }
        }
    }
}
