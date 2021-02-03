//
//  ThreadFooterView.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 30.01.2021.
//

import Cartography
import UIKit

class ThreadFooterView: UICollectionReusableView {
    // MARK: - UI Controls

    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        ai.color = .white
        return ai
    }()

    // MARK: - UI Actions

    private func setupUI() {
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        constrain(activityIndicator) { ai in
            ai.center == ai.superview!.center
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
