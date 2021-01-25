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

    let viewModel = HomeScreenViewModel() // Не приватный

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

        viewModel.requestBoards()
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
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.fetchedBoards.Разное.isEmpty {
            return 0
        }

        switch section {
        case 0:
            return viewModel.favBoards.count
        case 1:
            return min(7, viewModel.fetchedBoards.Взрослым.count)
        case 2:
            return min(7, viewModel.fetchedBoards.Игры.count)
        case 3:
            return min(7, viewModel.fetchedBoards.Политика.count)
        case 4:
            return min(7, viewModel.fetchedBoards.Пользовательские.count)
        case 5:
            return min(7, viewModel.fetchedBoards.Разное.count)
        case 6:
            return min(7, viewModel.fetchedBoards.Творчество.count)
        case 7:
            return min(7, viewModel.fetchedBoards.Тематика.count)
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! HomeScreenCell
        switch indexPath.section {
        case 0:
            cell.deskLabel.text = "/\(viewModel.favBoards[indexPath.item].boardKey ?? "")"
            cell.customTitleLabel.text = viewModel.favBoards[indexPath.item].boardName
        case 1:
            cell.deskLabel.text = "/\(viewModel.fetchedBoards.Взрослым[indexPath.item].id)"
            cell.customTitleLabel.text = viewModel.fetchedBoards.Взрослым[indexPath.item].name
        case 2:
            cell.deskLabel.text = "/\(viewModel.fetchedBoards.Игры[indexPath.item].id)"
            cell.customTitleLabel.text = viewModel.fetchedBoards.Игры[indexPath.item].name
        case 3:
            cell.deskLabel.text = "/\(viewModel.fetchedBoards.Политика[indexPath.item].id)"
            cell.customTitleLabel.text = viewModel.fetchedBoards.Политика[indexPath.item].name
        case 4:
            cell.deskLabel.text = "/\(viewModel.fetchedBoards.Пользовательские[indexPath.item].id)"
            cell.customTitleLabel.text = viewModel.fetchedBoards.Пользовательские[indexPath.item].name
        case 5:
            cell.deskLabel.text = "/\(viewModel.fetchedBoards.Разное[indexPath.item].id)"
            cell.customTitleLabel.text = viewModel.fetchedBoards.Разное[indexPath.item].name
        case 6:
            cell.deskLabel.text = "/\(viewModel.fetchedBoards.Творчество[indexPath.item].id)"
            cell.customTitleLabel.text = viewModel.fetchedBoards.Творчество[indexPath.item].name
        case 7:
            cell.deskLabel.text = "/\(viewModel.fetchedBoards.Тематика[indexPath.item].id)"
            cell.customTitleLabel.text = viewModel.fetchedBoards.Тематика[indexPath.item].name
        default:
            cell.customTitleLabel.text = "placeHolder"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Избранное"
        case 1:
            return "Взрослым"
        case 2:
            return "Игры"
        case 3:
            return "Политика"
        case 4:
            return "Пользовательские"
        case 5:
            return "Разное"
        case 6:
            return "Творчество"
        case 7:
            return "Тематика"
        default:
            return ""
        }
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
