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
    private var threadMessages: [Message]
    private let filter: String

    // MARK: = Public Properties

    var posts: [Message] {
        if !filter.isEmpty {
            return threadMessages.filter { String($0.num) == filter }
        }
        return threadMessages
    }

    var rawPosts: [Message] {
        return threadMessages
    }

    // MARK: - Data Binding

    var didUpdateHandler: (() -> Void)?

    // MARK: - Public Methods

    var replies: [String: [Int]] = [:]
    func findReplies() {
        posts.forEach { post in
            if !post.comment.detect(regex: "data-num").isEmpty {
                let bounds = post.comment.detect(regex: "data-num[^>]+>")
                bounds.forEach { bound in
                    let answerId = String(post.comment[
                        post.comment.index(bound.lowerBound,
                                           offsetBy: 10) ...
                            post.comment.index(bound.upperBound, offsetBy: -3)
                    ])

                    var postNums = replies[answerId] ?? []
                    postNums.append(post.num)
                    replies.updateValue(postNums, forKey: answerId)
                }
            }
        }
    }

    func requestThreadMessages() {
        NetworkService.sharedInstance.requestThreadMessages(withBoardKey: boardInfo.boardKey,
                                                            threadNumber: boardInfo.threadNum) { [weak self] result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)

            case let .success(threadMessages):
                self?.threadMessages = threadMessages.threads[0].posts
                self?.findReplies()
                self?.didUpdateHandler?()
            }
        }
    }

    // MARK: - Init

    init(boardInfo: BoardInfo, threadMessages: [Message] = [], filter: String = "") {
        self.boardInfo = boardInfo
        self.threadMessages = threadMessages
        self.filter = filter
    }
}
