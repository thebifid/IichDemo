//
//  ImageCell.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 08.02.2021.
//

import Cartography
import UIKit

class ImageCell: UICollectionViewCell {
    // MARK: - UI Controls

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    // MARK: - UI Actions

    private func setupUI() {
        addSubview(imageView)
        constrain(imageView) { imageView in
            imageView.edges == imageView.superview!.edges
        }
    }

    // MARK: Public Methods

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
