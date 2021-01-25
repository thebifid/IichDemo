//
//  HomeScreenViewController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 23.01.2021.
//

import CoreData
import UIKit

class HomeScreenViewController: UITableViewController {
    // MARK: - Private Properties

    let viewModel = HomeScreenViewModel() // Не приватный

    // MARK: - UI Controls

    let activityIndicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.hidesWhenStopped = true
        return ai
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // viewModel.requestBoards()
        setupNavigationBar()
        enableBinding()

        tableView.separatorColor = .black
        tableView.backgroundColor = R.color.background()
        tableView.register(HomeScreenCell.self, forCellReuseIdentifier: "id")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        viewModel.fetchDesk()
    }

    // MARK: - Binding

    private func enableBinding() {
        viewModel.updateTableViewHandler = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationItem.title = "Доски"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain,
                                                            target: self, action: #selector(plusButtonTapped))
    }

    // MARK: - Selectors

    @objc private func plusButtonTapped() {
        let alert = AlertAssist.alertWithInput(title: "Добавление доски", message: "Введите код доски") { [weak self] desk in
            self?.viewModel.saveDesk(withBoardKey: desk, completion: { [weak self] result in
                switch result {
                case let .failure(error):
                    DispatchQueue.main.async {
                        let alert = AlertAssist.alertWithOk(title: "Error", message: error.localizedDescription)
                        self?.present(alert, animated: true, completion: nil)
                    }

                case .success:
                    DispatchQueue.main.async {
                        self?.tableView.insertRows(at: [IndexPath(item: self!.viewModel.favBoards.count - 1, section: 0)], with: .fade)
                    }
                }
            })
        }
        present(alert, animated: true, completion: nil)
    }
}
