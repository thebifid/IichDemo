//
//  ThreadCell.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 25.01.2021.
//

import Atributika
import Cartography
import SDWebImage
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
        iv.contentMode = .scaleAspectFit
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

    let threadSubjectLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    let threadCommentLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        let all = Style.font(.systemFont(ofSize: 20))
        label.attributedText = "Thread first Message placeHolder".style(tags: all)
        return label
    }()

    enum CellCategory {
        case withSubject, noSubject
    }

    var cellCategory: CellCategory = .withSubject

    override func prepareForReuse() {
        super.prepareForReuse()
        firstImageView.image = nil
    }

    // MARK: - Public Methods

    func setupCell(withCellModel model: ThreadCellModel) {
        if model.boardKey == "b" {
            cellCategory = .noSubject
        } else {
            threadSubjectLabel.text = model.subject
        }

        setupUI()
        numberOfPostsLabel.text = "Постов: \(model.countPosts)"
        numberOfFilesLabel.text = "Файлов: \(model.countFiles)"
        let string = "\(model.comment)"

        let link = Style("a")
            .foregroundColor(.orange, .normal)

        threadCommentLabel.attributedText = string.style(tags: link)

        // images set
        if !model.files.isEmpty {
            let url = URL(string: "https://2ch.hk\(model.files[0].thumbnail!)")
            firstImageView.sd_setImage(with: url, completed: nil)
        }
    }

    // MARK: - UI Actions

    let group = ConstraintGroup()

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
            header.height == 120
        }

        headerForThreadImages.addSubview(firstImageView)
        constrain(firstImageView) { firstImageView in
            firstImageView.edges == firstImageView.superview!.edges
        }

        addSubview(threadAttachmentView)
        constrain(threadAttachmentView, headerForThreadImages, replace: group) { threadAttachmentView, headerForThreadImages in
            threadAttachmentView.top == headerForThreadImages.bottom
            threadAttachmentView.left == threadAttachmentView.superview!.left
            threadAttachmentView.right == threadAttachmentView.superview!.right

            if cellCategory == .noSubject {
                threadAttachmentView.height == 20
            } else {
                threadAttachmentView.height == 20 + (threadSubjectLabel.text?.height(constraintedWidth:
                    Constants.deviceWidth / 2 - 35) ?? 0)
            }
        }

        let stackView = UIStackView(arrangedSubviews: [numberOfPostsLabel, numberOfFilesLabel])

        stackView.spacing = 0
        stackView.distribution = .equalCentering

        let verticalStackView = UIStackView(arrangedSubviews: [stackView, threadSubjectLabel])
        verticalStackView.axis = .vertical

        threadAttachmentView.addSubview(verticalStackView)
        constrain(verticalStackView) { stackView in
            stackView.left == stackView.superview!.left + 10
            stackView.right == stackView.superview!.right - 10
            stackView.top == stackView.superview!.top + 5
        }

        addSubview(threadCommentLabel)
        constrain(threadCommentLabel, threadAttachmentView) { threadCommentLabel, threadAttachmentView in
            threadCommentLabel.left == threadCommentLabel.superview!.left + 10
            threadCommentLabel.right == threadCommentLabel.superview!.right - 10
            threadCommentLabel.top == threadAttachmentView.bottom + 5
            threadCommentLabel.bottom == threadCommentLabel.superview!.bottom
        }
        threadCommentLabel.sizeToFit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont = .systemFont(ofSize: 14)) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
}
