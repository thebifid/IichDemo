//
//  ThreadScreenViewController.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 01.02.2021.
//

import Cartography
import UIKit

class ThreadScreenViewController: UITableViewController {
    // MARK: - Private Properties

    private let viewModel: ThreadScreenViewModel

    // MARK: - UI Controls

    private let activityIndicatorView: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .large)
        ai.color = .white
        ai.hidesWhenStopped = true
        return ai
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        enableDataBinding()
        makeRequest()
        setupTableView()
        setupRightBarButton()
    }

    // MARK: - Selectors

    @objc private func openGallery() {}

    // MARK: - Private Methods

    private func setupRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "tablecells"),
                                                            style: .plain, target: self, action: #selector(openGallery))
    }

    private func makeRequest() {
        if viewModel.posts.isEmpty {
            activityIndicatorView.startAnimating()
            viewModel.requestThreadMessages()
        }
    }

    // MARK: - UI Actions

    private func setupTableView() {
        tableView.separatorColor = .gray
        tableView.allowsSelection = false
        tableView.register(MessageCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = R.color.background()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.addSubview(activityIndicatorView)
        constrain(activityIndicatorView) { ai in
            ai.centerX == ai.superview!.centerX
            ai.top == ai.superview!.top + 100
        }
    }

    // MARK: - Data Binding

    private func enableDataBinding() {
        viewModel.didUpdateHandler = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                UIView.transition(with: self.tableView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                      self.tableView.reloadData()
                                  })
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

        cell.didReplyLinkClicked = { [weak self] postNumber in
            guard let self = self else { return }
            let vm = ThreadScreenViewModel(boardInfo: BoardInfo(), threadMessages: self.viewModel.rawPosts, onePostShow: postNumber)
            let vc = ThreadScreenViewController(viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        cell.didAnswersButtonClicked = { [weak self] postNumber in
            guard let self = self else { return }
            let vm = ThreadScreenViewModel(boardInfo: BoardInfo(), threadMessages: self.viewModel.rawPosts, filter: postNumber)
            let vc = ThreadScreenViewController(viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        cell.didImageClicked = { [weak self] dict in
            if let originalPath = self?.viewModel.posts[dict.first!.key - 1]
                .files.first(where: { dict.first!.value.contains($0.thumbnail!) })?.path {
                let galleryVC = GalleryViewController(pathToOriginal: originalPath)
                let navGalleryVC = UINavigationController(rootViewController: galleryVC)
                navGalleryVC.modalPresentationStyle = .fullScreen
                self?.present(navGalleryVC, animated: true, completion: nil)
            }
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
