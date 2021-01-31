//
//  ThreadScreenViewController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 25.01.2021.
//

import Cartography
import UIKit

class ThreadScreenViewController: UIViewController, UISearchBarDelegate {
    // MARK: - Private Properties

    private var viewModel: ThreadScreenViewModel

    // MARK: - UI Controls

    var myCollectionView: UICollectionView?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        enableBinding()
        viewModel.requestThreads { _ in }
        setupCollectionView()
        setupSearchBar()
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
        collectionView.register(ThreadFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footerId")

        view.addSubview(collectionView)
        constrain(collectionView) { collectionView in
            collectionView.edges == collectionView.superview!.edges
        }
        collectionView.backgroundColor = R.color.background()
    }

    private func setupSearchBar() {
        let customSearchController = CustomSearchController()
        (customSearchController.searchBar as! SearchBar).searchIconColor = .white
        (customSearchController.searchBar as! SearchBar).textColor = .white
        (customSearchController.searchBar as! SearchBar).placeholderColor = R.color.moredark()
        customSearchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = customSearchController
        customSearchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    // MARK: - UI Actions

    private func setupUI() {}

    // MARK: - Init

    init(viewModel: ThreadScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterData(withStirng: searchText)
        viewModel.searchTerms = searchText
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = viewModel.searchTerms
    }
}

extension ThreadScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredData.threads.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: Constants.deviceWidth / 2 - 10, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ThreadCell
        cell.setupCell(withCellModel: viewModel.formCellModel(index: indexPath.item))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerId",
                                                                             for: indexPath) as! ThreadFooterView
            if !viewModel.searchTerms.isEmpty {
                footerView.isHidden = true
            } else {
                footerView.isHidden = false
            }
            return footerView

        default:
            assert(false, "Invalid element type")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: Constants.deviceWidth, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.boardList.threads.count - 1 {
            viewModel.requestThreads { result in
                switch result {
                case let .failure(error):
                    print(error.localizedDescription)
                case .success:
                    DispatchQueue.main.async {
                        self.myCollectionView!.reloadData()
                    }
                }
            }
        }
    }
}
