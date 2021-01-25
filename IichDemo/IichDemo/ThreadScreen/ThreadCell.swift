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
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFit
        iv.image = R.image.appleTest()
        return iv
    }()

    let secondImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFit
        iv.image = R.image.flowers()
        return iv
    }()

    let thirdImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFit
        iv.image = R.image.moto()
        return iv
    }()

    let fourthImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFit
        iv.image = R.image.space()
        return iv
    }()

    let threadMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.text = """
        Аноны, расскажите как вы выучили английский? Какой у вас уровень знания языка, как дошли до этого. У меня мечта знать инглиш на уровне B1-B2, но я едва ли единичные слова понимаю на слух.
        Вообще, похоже у меня какой-то кретинизм на этой теме, никогда языки хорошо не шли.
        """

        return label
    }()

    // MARK: - UI Actions

    private func setupUI() {
        backgroundColor = .orange
        layer.cornerRadius = 15

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

        addSubview(threadMessageLabel)
        constrain(threadMessageLabel, headerForThreadImages) { threadMessageLabel, header in
            threadMessageLabel.left == threadMessageLabel.superview!.left + 10
            threadMessageLabel.right == threadMessageLabel.superview!.right - 10
            threadMessageLabel.top == header.bottom
            threadMessageLabel.bottom == threadMessageLabel.superview!.bottom - 10
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
