//
//  HomeScreenViewController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 23.01.2021.
//

import Cartography
import CoreData
import UIKit

class HomeScreenViewController: UITableViewController {
    // MARK: - Private Properties

    private let viewModel = HomeScreenViewModel()

    // MARK: - UI Controls

    let activityIndicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .white
        ai.startAnimating()
        ai.hidesWhenStopped = true
        return ai
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        requestBoards()
        setupNavigationBar()
        enableBinding()

        setupAi()

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
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }

    // MARK: - Private Methods

    private func requestBoards() {
        viewModel.requestBoards { [weak self] result in
            switch result {
            case let .failure(error):
                let alert = AlertAssist.alertWithOk(title: "Error loading boards", message: error.localizedDescription)
                self?.present(alert, animated: true, completion: nil)
            case .success:
                break
            }
        }
    }

    private func setupAi() {
        tableView.addSubview(activityIndicatorView)
        constrain(activityIndicatorView) { ai in
            ai.center == ai.superview!.center
        }
    }

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

extension HomeScreenViewController {
    // MARK: - TableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.arrayOfAllBoards.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.arrayOfAllBoards.isEmpty {
            return 0
        }
        return min(3, viewModel.arrayOfAllBoards[section].count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! HomeScreenCell
        cell.deskLabel.text = "/\(viewModel.arrayOfAllBoards[indexPath.section][indexPath.row].id)"
        cell.customTitleLabel.text = viewModel.arrayOfAllBoards[indexPath.section][indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let viewModelToSend = ThreadScreenViewModel(boardInfo: viewModel.arrayOfAllBoards[indexPath.section][indexPath.row])
//      // let viewController = ThreadScreenViewController(viewModel: viewModelToSend)
//        viewController.navigationItem.title = viewModelToSend.boardInfo.name
//        navigationController?.pushViewController(viewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.arrayOfAllBoards[section].first?.category ?? "PlaceHolder"
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = R.color.background()
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.fetchedBoards.Разное.isEmpty {
            return 0
        }
        return 30
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deleteObject = viewModel.favBoards[indexPath.item]
            viewModel.deleteDesk(objectToDelete: deleteObject)
            viewModel.favBoards.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
