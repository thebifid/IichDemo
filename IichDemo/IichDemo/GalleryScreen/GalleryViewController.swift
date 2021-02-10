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
    // MARK: - Private Propertie

    private var viewModel: GalleryViewModel

    // MARK: - UI Controls

    private var collectionView: UICollectionView?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = viewModel.scrollToIndexPath {
            collectionView?.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }

    // MARK: = UI Actions

    private func setupUI() {
        navigationItem.title = "Gallery"

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 20, left: 5, bottom: 20, right: 5)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cellId")

        self.collectionView = collectionView

        view.addSubview(collectionView)
        constrain(collectionView) { collectionView in
            collectionView.edges == collectionView.superview!.edges
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

    init(viewModel: GalleryViewModel, openAtPosition positon: Int?) {
        self.viewModel = viewModel
        self.viewModel.scrollToIndex = positon
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.files.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ImageCell
        let url = URL(string: "https://2ch.hk\(viewModel.files[indexPath.row].path!)")
        cell.imageView.sd_setImage(with: url!, completed: nil)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Constants.deviceWidth, height: 600)
    }
}
