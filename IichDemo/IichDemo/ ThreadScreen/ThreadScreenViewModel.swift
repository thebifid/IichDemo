//
//  ThreadScreenViewModel.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 01.02.2021.
//

import Foundation

class ThreadScreenViewModel {
    // MARK: - Private Properties

    private let boardInfo: BoardInfo
    private var threadMessages: [Message] = []

    // MARK: = Public Properties

    var posts: [Message] {
        return threadMessages
    }

    // MARK: - Data Binding

    var didUpdateHandler: (() -> Void)?

    // MARK: - Public Methods

    func requestThreadMessages() {
        NetworkService.sharedInstance.requestThreadMessages(withBoardKey: boardInfo.boardKey,
                                                            threadNumber: boardInfo.threadNum) { [weak self] result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)

            case let .success(threadMessages):
                self?.threadMessages = threadMessages.threads[0].posts
                self?.didUpdateHandler?()
            }
        }
    }

    // MARK: - Init

    init(boardInfo: BoardInfo) {
        self.boardInfo = boardInfo
    }
}
