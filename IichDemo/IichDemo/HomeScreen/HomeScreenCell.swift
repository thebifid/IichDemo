//
//  HomeScreenCell.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 24.01.2021.
//

import Cartography
import UIKit

class HomeScreenCell: UITableViewCell {
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Controls

    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.background()
        return view
    }()

    let deskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = ""
        return label
    }()

    let customTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    // MARK: - UI Actions

    private func setupUI() {
        backgroundColor = R.color.moredark()

        addSubview(circleView)
        constrain(circleView) { circleView in
            circleView.left == circleView.superview!.left + 20
            circleView.centerY == circleView.superview!.centerY
            circleView.height == circleView.superview!.height / 1.2
            circleView.width == circleView.height
        }
        circleView.layer.cornerRadius = frame.height / 2

        circleView.addSubview(deskLabel)
        constrain(deskLabel) { deskLabel in
            deskLabel.center == deskLabel.superview!.center
        }

        addSubview(customTitleLabel)
        constrain(customTitleLabel, circleView) { customTitleLabel, circleView in
            customTitleLabel.centerY == circleView.centerY
            customTitleLabel.left == circleView.right + 10
        }
    }
}
