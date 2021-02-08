//
//  GalleryViewController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 08.02.2021.
//

import Cartography
import SDWebImage
import UIKit

class GalleryViewController: UIViewController {
    // MARK: - UI Controls

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: = UI Actions

    private func setupUI() {
        view.backgroundColor = .orange
        navigationItem.title = "Gallery"

        view.addSubview(imageView)
        constrain(imageView) { imageView in
            imageView.edges == imageView.superview!.edges
        }

        navigationItem.title = "Gallery"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"),
                                                            style: .plain, target: self, action: #selector(goBack))
    }

    // MARK: - Selectors

    @objc private func goBack() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private Methods

    private func loadImage(withURLString string: String) {
        guard let url = URL(string: "https://2ch.hk\(string)") else { return }
        imageView.sd_setImage(with: url, completed: nil)
    }

    init(pathToOriginal path: String) {
        super.init(nibName: nil, bundle: nil)
        loadImage(withURLString: path)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
