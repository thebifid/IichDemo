//
//  ThreadCell.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 25.01.2021.
//

import Cartography
import UIKit

class ThreadCell: UICollectionViewCell {
    // MARK: - UI Controls

    let headerForThreadImages: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.moredark()
        return view
    }()

    let firstImageView: UIImageView = {
        let iv = UIImageView()
        // iv.backgroundColor = .black
        iv.contentMode = .scaleToFill
        iv.image = R.image.appleTest()
        return iv
    }()

    let secondImageView: UIImageView = {
        let iv = UIImageView()
        // iv.backgroundColor = .black
        iv.contentMode = .scaleToFill
        iv.image = R.image.flowers()
        return iv
    }()

    let thirdImageView: UIImageView = {
        let iv = UIImageView()
        // iv.backgroundColor = .black
        iv.contentMode = .scaleToFill
        iv.image = R.image.moto()
        return iv
    }()

    let fourthImageView: UIImageView = {
        let iv = UIImageView()
        // iv.backgroundColor = .black
        iv.contentMode = .scaleToFill
        iv.image = R.image.space()
        return iv
    }()

    let threadAttachmentView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.background()
        return view
    }()

    let numberOfPostsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 12)
        label.text = "Постов: 137"
        return label
    }()

    let numberOfFilesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 12)
        label.text = "Файлов: 90"
        return label
    }()

    let threadSubjLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Thread first Message placeHolder"
        return label
    }()

    // MARK: - UI Actions

    private func setupUI() {
        backgroundColor = R.color.moredark()
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor

        addSubview(headerForThreadImages)
        clipsToBounds = true

        constrain(headerForThreadImages) { header in
            header.top == header.superview!.top
            header.left == header.superview!.left
            header.right == header.superview!.right
            header.height == 40
        }

        let imagesStackView = UIStackView(arrangedSubviews: [firstImageView, secondImageView, thirdImageView, fourthImageView])
        imagesStackView.spacing = 2
        imagesStackView.distribution = .fillEqually

        headerForThreadImages.addSubview(imagesStackView)
        constrain(imagesStackView) { imagesStackView in
            imagesStackView.edges == imagesStackView.superview!.edges
        }

        addSubview(threadAttachmentView)
        constrain(threadAttachmentView, headerForThreadImages) { threadAttachmentView, headerForThreadImages in
            threadAttachmentView.top == headerForThreadImages.bottom
            threadAttachmentView.left == threadAttachmentView.superview!.left
            threadAttachmentView.right == threadAttachmentView.superview!.right
            threadAttachmentView.height == 25
        }

        threadAttachmentView.addSubview(numberOfPostsLabel)
        threadAttachmentView.addSubview(numberOfFilesLabel)
        constrain(numberOfPostsLabel, numberOfFilesLabel) { numberOfPostsLabel, numberOfFilesLabel in
            numberOfPostsLabel.left == numberOfPostsLabel.superview!.left + 10
            numberOfPostsLabel.centerY == numberOfPostsLabel.superview!.centerY

            numberOfFilesLabel.left == numberOfPostsLabel.right + 10
            numberOfFilesLabel.centerY == numberOfPostsLabel.centerY
        }

        addSubview(threadSubjLabel)
        constrain(threadSubjLabel, threadAttachmentView) { threadSubjLabel, threadAttachmentView in
            threadSubjLabel.left == threadSubjLabel.superview!.left + 10
            threadSubjLabel.right == threadSubjLabel.superview!.right - 10
            threadSubjLabel.top == threadAttachmentView.bottom
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
