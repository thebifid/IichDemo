//
//  ThreadScreenViewController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 25.01.2021.
//

import Cartography
import UIKit

class ThreadScreenViewController: UIViewController {
    // MARK: - Private Properties

    private var viewModel: ThreadScreenViewModel = ThreadScreenViewModel()

    // MARK: - UI Controls

    var myCollectionView: UICollectionView?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        enableBinding()
        viewModel.requestThreads(withBoardKey: "b") { _ in }
        setupCollectionView()
    }

    // MARK: - Private Methods

    private func enableBinding() {
        viewModel.didUpdateModel = { [weak self] in
            DispatchQueue.main.async {
                self?.myCollectionView?.reloadData()
            }
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()

        layout.sectionInset = .init(top: 20, left: 5, bottom: 20, right: 5)

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        myCollectionView = collectionView

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(ThreadCell.self, forCellWithReuseIdentifier: "cellId")

        view.addSubview(collectionView)
        constrain(collectionView) { collectionView in
            collectionView.edges == collectionView.superview!.edges
        }
        collectionView.backgroundColor = R.color.background()
    }

    // MARK: - UI Actions

    private func setupUI() {}

    // MARK: - Init

    //
    //    init(viewModel: ThreadScreenViewModel) {
    //       // self.viewModel = viewModel
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
}

extension ThreadScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.boardList.threads.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Constants.deviceWidth / 2 - 10, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ThreadCell
        cell.setupCell(withCellModel: viewModel.formCellModel(index: indexPath.item))
        return cell
    }
}
