//
//  BoardInfo.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 24.01.2021.
//

import Foundation

struct BoardInfo {
    let boardName: String
    let boardKey: String
    let threadNum: String

    init(boardName: String, boardKey: String, threadNum: String) {
        self.boardName = boardName
        self.boardKey = boardKey
        self.threadNum = threadNum
    }

    init() {
        boardName = ""
        boardKey = ""
        threadNum = ""
    }
}
