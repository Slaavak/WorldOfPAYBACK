//
//  NetworkServiceMocked.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 26.10.22.
//

import Foundation

class NetworkServiceMocked: NetworkHelperProtocol {

    private var delaySimulation: DispatchTime = .now() + 3

    func getTransactions(
        success: @escaping (TransactionsEntityProtocol) -> Void,
        failure: @escaping ((String) -> Void),
        initInterface: @escaping (VoidBlock)
    ) {
        initInterface()
        DispatchQueue.global().asyncAfter(deadline: delaySimulation) {
            if let url = Bundle.main.url(forResource: Constants.fileName, withExtension: Constants.fileExtension) {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(PBTransactions.self, from: data)
                    DispatchQueue.performOnMainThread {
                        success(jsonData)
                    }
                } catch {
                    DispatchQueue.performOnMainThread {
                        failure(Constants.errorString + "\(error)")
                    }
                }
            }
        }
    }

    //MARK: - Constants

    private enum Constants {
        static let fileName = "PBTransactions"
        static let fileExtension = "json"
        static let errorString = "error:"
    }
}
