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

    // MARK: - Handlers

    var didUpdateModel: (() -> Void)?

    // MARK: - Public Methods

    func requestThreads(withBoardKey boardKey: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        NetworkService.sharedInstance.requestBoardInfo(boardKey: boardKey) { [weak self] result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(boardList):
                self?.boardList = boardList
                self?.didUpdateModel?()
                completion(.success(()))
            }
        }
    }

    func formCellModel(index: Int) -> ThreadCellModel {
        let data = boardList.threads[index].posts[0]
        return ThreadCellModel(countFiles: data.files_count ?? 0,
                               countPosts: data.posts_count ?? 0, subject: data.subject, comment: data.comment, files: data.files)
    }

    // MARK: - Init

    init(boardInfo: BoardModel) {
        self.boardInfo = boardInfo
    }
}
