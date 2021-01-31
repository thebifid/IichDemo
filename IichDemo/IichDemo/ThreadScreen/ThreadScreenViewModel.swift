//
//  ThreadScreenViewModel.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 25.01.2021.
//

import Foundation

class ThreadScreenViewModel {
    // MARK: - Private Properties

    // MARK: - Public Properties

    let boardInfo: BoardModel
    var boardList: BoardListModel = BoardListModel()
    var currentPage: Int = 0
    var filteredData: BoardListModel = BoardListModel()

    var searchTerms: String = ""

    // MARK: - Handlers

    var didUpdateModel: (() -> Void)?

    // MARK: - Public Methods

    func filterData(withStirng searchString: String) {
        filteredData = BoardListModel()

        if searchString.isEmpty {
            filteredData = boardList
        } else {
            boardList.threads.forEach { thread in
                let fullSubject = "\(thread.posts[0].subject) \(thread.posts[0].comment)"
                if fullSubject.lowercased().contains(searchString.lowercased()) {
                    filteredData.threads.append(thread)
                }
            }
        }

        didUpdateModel?()
    }

    func requestThreads(completion: @escaping ((Result<Void, Error>) -> Void)) {
        NetworkService.sharedInstance.requestBoardInfo(boardKey: boardInfo.id, pageNumber: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(boardList):
                self.boardList.threads.append(contentsOf: boardList.threads)
                self.filteredData = self.boardList
                self.currentPage += 1
                self.didUpdateModel?()
                completion(.success(()))
            }
        }
    }

    func formCellModel(index: Int) -> ThreadCellModel {
        let data = filteredData.threads[index].posts[0]
        return ThreadCellModel(countFiles: data.files_count ?? 0,
                               countPosts: data.posts_count ?? 0, subject: data.subject,
                               comment: data.comment, files: data.files, boardKey: boardInfo.id)
    }

    // MARK: - Init

    init(boardInfo: BoardModel) {
        self.boardInfo = boardInfo
        boardList.Board = boardInfo.id
        boardList.BoardName = boardInfo.name
    }
}
