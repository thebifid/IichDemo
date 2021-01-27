//
//  ThreadScreenViewModel.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 25.01.2021.
//

import Foundation

class ThreadScreenViewModel {
    // MARK: - Public Properties

    var boardList: BoardListModel = BoardListModel()

    // MARK: - Handlers

    var didUpdateModel: (() -> Void)?

    // MARK: - Private Properties

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

    // MARK: - Init

    //    init(boardInfo: BoardModel) {
    //        self.boardInfo = boardInfo
    //    }
}
