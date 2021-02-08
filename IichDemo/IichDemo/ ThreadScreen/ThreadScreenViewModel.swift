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
    private let filter: Int
    private let onePostShow: Int

    // MARK: - Cache

    var cachedFilteredData: [Message] = []
    var cachedFilterPost: [Message] = []

    // MARK: - Public Properties

    var replies: [String: [Int]] = [:]

    var rawPosts: [Message] {
        return threadMessages
    }

    var posts: [Message] {
        if filter != 0 {
            return filtedData(withFiler: filter)
        }
        if onePostShow != 0 {
            switch filterPost(postsNum: onePostShow) {
            case let .success(message):
                return message
            default:
                break
            }
        }

        return threadMessages
    }

    func filtedData(withFiler filter: Int) -> [Message] {
        guard cachedFilteredData.isEmpty else { return cachedFilteredData }
        var filteredNums: [Int] = []
        var filtered: [Message] = []
        filteredNums = threadMessages.first(where: { $0.num == filter })?.replies ?? []
        filteredNums.forEach { filtNum in
            filtered += threadMessages.filter { $0.num == filtNum }
        }
        cachedFilteredData = filtered
        return filtered
    }

    func filterPost(postsNum: Int) -> Result<[Message], Error> {
        guard cachedFilterPost.isEmpty else { return .success(cachedFilterPost) }
        var message: [Message] = []
        if let post = threadMessages.first(where: { $0.num == postsNum }) {
            message.append(post)
            cachedFilterPost = message
            return .success(message)
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Нет такого поста"])
            return .failure(error)
        }
    }

    // MARK: - Data Binding

    var didUpdateHandler: (() -> Void)?

    // MARK: - Public Methods

    func findReplies() {
        posts.enumerated().forEach { _, post in
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
        repliesToModel()
    }

    func repliesToModel() {
        replies.forEach { reply in
            if let index = threadMessages.firstIndex(where: { $0.num == Int(reply.key) }) {
                threadMessages[index].replies = reply.value
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

    init(boardInfo: BoardInfo, threadMessages: [Message] = [], filter: Int = 0, onePostShow: Int = 0) {
        self.boardInfo = boardInfo
        self.threadMessages = threadMessages
        self.filter = filter
        self.onePostShow = onePostShow
    }
}
