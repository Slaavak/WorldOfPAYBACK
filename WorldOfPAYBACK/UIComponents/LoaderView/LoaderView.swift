//
//  LoaderView.swift
//  WorldOfPAYBACK
//
//  Created by Slava Korolevich on 26.10.22.
//

import Foundation
import UIKit

public class LoaderView: UIViewController {

    //MARK: - Outlets

    @IBOutlet private weak var activitiIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backView: UIView!

    //MARK: - Lyfecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    //MARK: - Actions

    private func setupUI() {
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        activitiIndicator.startAnimating()
    }
}
