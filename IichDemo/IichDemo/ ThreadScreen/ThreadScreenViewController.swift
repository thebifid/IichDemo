//
//  ThreadScreenViewController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 01.02.2021.
//

import UIKit

class ThreadScreenViewController: UITableViewController {
    // MARK: - Private Properties

    private let viewModel: ThreadScreenViewModel

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        enableDataBinding()
        tableView.separatorColor = .gray
        tableView.allowsSelection = false
        tableView.register(MessageCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = R.color.background()

        if viewModel.posts.isEmpty {
            viewModel.requestThreadMessages()
        } else {}

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    // MARK: - Data Binding

    private func enableDataBinding() {
        viewModel.didUpdateHandler = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - tableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MessageCell

        cell.didReplyLinkClicked = { _ in
        }

        cell.didAnswersButtonClicked = { postNumber in
            let vm = ThreadScreenViewModel(boardInfo: BoardInfo(), threadMessages: self.viewModel.rawPosts, filter: postNumber)
            let vc = ThreadScreenViewController(viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        cell.setupCell(message: viewModel.posts[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Init

    init(viewModel: ThreadScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
