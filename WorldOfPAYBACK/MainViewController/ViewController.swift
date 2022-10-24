//
//  ViewController.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 24.10.22.
//

import UIKit

class ViewController: UIViewController {

    private var networkHelper: NetworkHelperProtocol!


    override func viewDidLoad() {
        super.viewDidLoad()
        networkHelper = NetworkHelper()

        networkHelper.getTransactions(
            success: { [weak self] response in
                guard let self = self else {
                    return
                }
                response.items.first?.alias
            },
            failure: {
                let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
            },
            initInterface: {

            },
            finalizeInterface: {

            })
    }
}

