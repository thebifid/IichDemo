//
//  MessageCell.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 01.02.2021.
//

import Atributika
import Cartography
import SDWebImage
import UIKit

class MessageCell: UITableViewCell {
    // MARK: - UI Controls

    private let messageInfoView: UIView = {
        let view = UIView()
        return view
    }()

    private let messageInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private let imagesViewView: UIView = {
        let view = UIView()
        return view
    }()

    private let firstImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let secondImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let thirdImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let fourthImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let messageLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()

    private let bottomView: UIView = {
        let view = UIView()
        return view
    }()

    private let answersButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitleColor(.orange, for: .normal)
        return button
    }()

    private let timeAgoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()

    private lazy var imagesStackView = UIStackView(arrangedSubviews: [firstImageView, secondImageView, thirdImageView, fourthImageView])

    // MARK: - Handlers

    var didReplyLinkClicked: ((String) -> Void)?

    // MARK: - Private Properties

    private let group = ConstraintGroup()

    // MARK: - Public Methods

    override func prepareForReuse() {
        super.prepareForReuse()
        firstImageView.image = nil
        secondImageView.image = nil
        thirdImageView.image = nil
        fourthImageView.image = nil
    }

    func setupCell(message: Message, replies: [Int]) {
        if !replies.isEmpty {
            answersButton.setTitle("\(replies.count) replies", for: .normal)
        }

        let timeAgo = Date().offsetFrom(date: Date(timeIntervalSince1970: TimeInterval(message.timestamp)))
        timeAgoLabel.text = "\(timeAgo)"

        messageInfoLabel.text = "#\(message.number) • \(message.num)"

        let all = Style.font(.systemFont(ofSize: 20))
        let link = Style("a").foregroundColor(.orange, .normal).foregroundColor(.gray, .highlighted)
        let strong = Style("strong").font(.boldSystemFont(ofSize: 18))
        let h3 = Style("h3")
        let spoiler = Style("spoiler")
            .foregroundColor(.clear, .normal)
            .foregroundColor(.white, .highlighted)
            .backgroundColor(.gray, .normal)
            .backgroundColor(.clear, .highlighted)
        let quote = Style("quote").foregroundColor(R.color.quoteGreen()!)
        let strikethrough = Style("strikethrough").strikethroughStyle(NSUnderlineStyle.single)
        let em = Style("em").font(.italicSystemFont(ofSize: 18))

        messageLabel.attributedText = message.comment.fromSpanToTag(className: [.quote, .spoiler, .strikethrough])
            .spacingBetweenBlockTags()
            .style(tags: link, strong, h3, spoiler, quote, strikethrough, em, all)

        messageLabel.isUserInteractionEnabled = true

        messageLabel.onClick = { [weak self] label, detection in
            switch detection.type {
            case let .tag(tag):
                if tag.name == "spoiler" {
                    label.attributedText = label.attributedText?
                        .style(range: detection.range, style: Style().foregroundColor(.white, .normal).backgroundColor(.clear, .normal))
                }

                if tag.name == "a" {
                    guard let parentNum = tag.attributes["data-num"] else { return }
                    self?.didReplyLinkClicked?(parentNum)
                }

            default:
                break
            }
        }

        if !message.files.isEmpty {
            guard let url = URL(string: "https://2ch.hk\(message.files[0].thumbnail!)") else { return }
            firstImageView.sd_setImage(with: url, completed: nil)
            if message.files.count > 1 {
                guard let url = URL(string: "https://2ch.hk\(message.files[1].thumbnail!)") else { return }
                secondImageView.sd_setImage(with: url, completed: nil)

                if message.files.count > 2 {
                    guard let url = URL(string: "https://2ch.hk\(message.files[2].thumbnail!)") else { return }
                    thirdImageView.sd_setImage(with: url, completed: nil)

                    if message.files.count > 3 {
                        guard let url = URL(string: "https://2ch.hk\(message.files[3].thumbnail!)") else { return }
                        fourthImageView.sd_setImage(with: url, completed: nil)
                    }
                }
            }
        }
        setupUI(haveAttachements: !message.files.isEmpty)
    }

    // MARK: - UI Actions

    private func setupUI(haveAttachements: Bool) {
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        backgroundColor = R.color.moredark()

        addSubview(messageInfoView)
        constrain(messageInfoView) { messageInfoView in
            messageInfoView.top == messageInfoView.superview!.top
            messageInfoView.left == messageInfoView.superview!.left
            messageInfoView.right == messageInfoView.superview!.right
            messageInfoView.height == 30
        }

        messageInfoView.addSubview(messageInfoLabel)
        constrain(messageInfoLabel) { message in
            message.centerY == message.superview!.centerY
            message.left == message.superview!.left + 10
        }

        imagesViewView.clipsToBounds = true
        addSubview(imagesViewView)
        constrain(imagesViewView, messageInfoView, replace: group) { ivv, messageInfoView in
            ivv.top == messageInfoView.bottom
            ivv.left == ivv.superview!.left
            ivv.right == ivv.superview!.right

            if haveAttachements {
                ivv.height == 80
            } else {
                ivv.height == 0
            }
        }

        imagesStackView.distribution = .fillEqually
        imagesStackView.spacing = 5

        imagesViewView.addSubview(imagesStackView)
        constrain(imagesStackView) { imagesStackView in
            imagesStackView.left == imagesStackView.superview!.left + 10
            imagesStackView.centerY == imagesStackView.superview!.centerY
            imagesStackView.width == Constants.deviceWidth * 0.8
            imagesStackView.height == imagesStackView.superview!.height
        }

        addSubview(bottomView)
        constrain(bottomView) { bottomView in
            bottomView.bottom == bottomView.superview!.bottom - 5
            bottomView.right == bottomView.superview!.right
            bottomView.left == bottomView.superview!.left
            bottomView.height == 30
        }

        bottomView.addSubview(answersButton)
        constrain(answersButton) { answersButton in
            answersButton.centerY == answersButton.superview!.centerY
            answersButton.right == answersButton.superview!.right - 15
            answersButton.height == answersButton.superview!.height * 0.8
        }

        bottomView.addSubview(timeAgoLabel)
        constrain(timeAgoLabel) { timeAgoLabel in
            timeAgoLabel.centerY == timeAgoLabel.superview!.centerY
            timeAgoLabel.left == timeAgoLabel.superview!.left + 10
        }

        addSubview(messageLabel)
        constrain(messageLabel, imagesViewView, bottomView) { messageLabel, iv, bv in
            messageLabel.left == messageLabel.superview!.left + 10
            messageLabel.right == messageLabel.superview!.right - 10
            messageLabel.top == iv.bottom + 5
            messageLabel.bottom == bv.top ~ UILayoutPriority(999)
        }
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
