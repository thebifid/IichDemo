//
//  HomeScreenViewController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 23.01.2021.
//

import UIKit

class HomeScreenViewController: UITableViewController {
    let viewModel = HomeScreenViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()

        tableView.backgroundColor = R.color.background()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
    }

    // MARK: - Private Methods

    private func setupNavigationBar() {
        navigationItem.title = "Доски"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain,
                                                            target: self, action: #selector(plusButtonTapped))
    }

    // MARK: - Selectors

    @objc private func plusButtonTapped() {
        let alert = AlertAssist.alertWithInput(title: "Добавление доски", message: "Введите код доски", handler: { _ in
            print("hello")
        })
        present(alert, animated: true, completion: nil)
    }

    // MARK: - TableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        cell.textLabel?.text = "111"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Избранное"
    }
}
