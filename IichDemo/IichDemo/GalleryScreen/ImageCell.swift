//
//  ImageCell.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 08.02.2021.
//

import Cartography
import SDWebImage
import UIKit

class ImageCell: UICollectionViewCell {
    // MARK: - UI Controls

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let progressDownloadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 6
        view.layer.opacity = 0.4
        return view
    }()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .white
        return ai
    }()

    private let progressDonwloadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0% loading"
        label.numberOfLines = 0
        return label
    }()

    // MARK: - UI Actions

    private func setupUI() {
        addSubview(imageView)
        constrain(imageView) { imageView in
            imageView.edges == imageView.superview!.edges
        }

        imageView.addSubview(progressDownloadingView)
        constrain(progressDownloadingView) { pdv in
            pdv.center == pdv.superview!.center
            pdv.height == 120
            pdv.width == 120
        }

        let progressStackView = UIStackView(arrangedSubviews: [activityIndicatorView, progressDonwloadingLabel])
        progressStackView.axis = .vertical
        progressStackView.spacing = 4
        progressStackView.alignment = .center

        progressDownloadingView.addSubview(progressStackView)
        constrain(progressStackView) { progressStackView in
            progressStackView.centerY == progressStackView.superview!.centerY
            progressStackView.left == progressStackView.superview!.left
            progressStackView.right == progressStackView.superview!.right
        }
    }

    private lazy var completeDownloadHandler: SDExternalCompletionBlock = { [weak self] _, _, _, _ in
        self?.progressDownloadingView.isHidden = true
    }

    // MARK: Public Methods

    func setupCell(file: Attachements) {
        let placeHolderURL = URL(string: "https://2ch.hk\(file.thumbnail!)")

        let placeHolderImageView = UIImageView()
        placeHolderImageView.sd_setImage(with: placeHolderURL, placeholderImage: nil, options: .fromCacheOnly, completed: nil)

        let url = URL(string: "https://2ch.hk/\(file.path!)")
        imageView.sd_setImage(with: url, placeholderImage: placeHolderImageView.image, options: .waitStoreCache,
                              progress: { [weak self] int1, int2, _ in
                                  DispatchQueue.main.async {
                                      self?.progressDownloadingView.isHidden = false
                                      self?.activityIndicatorView.startAnimating()
                                      let percent = Float(int1) / Float(int2) * 100
                                      self?.progressDonwloadingLabel.text = "\(String(format: "%.0f", percent))% loading"
                                  }
                              }, completed: completeDownloadHandler)
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
