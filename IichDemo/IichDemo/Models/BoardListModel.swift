//
//  BoardListModel.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 27.01.2021.
//

import Foundation

struct BoardListModel: Decodable {
    let Board: String
    let BoardName: String
    let threads: [Thread]

    init() {
        Board = ""
        BoardName = ""
        threads = []
    }
}

struct Thread: Decodable {
    let files_count: Int
    let posts: [Posts]
    let posts_count: Int
    let thread_num: String
}

struct Posts: Decodable {
    let banned: Int
    let closed: Int
    let comment: String
    let date: String
    let email: String
    let endless: Int
    let files: [Files]
    let lasthit: Int
    let name: String
    let num: String
    let op: Int
    let parent: String
    let posts_count: Int?

    let sticky: Int
    let subject: String
    let timestamp: Int
}

struct Files: Decodable {
    let displayname: String
    let fullname: String
    let height: Int
    let name: String
    let nsfw: Int
    let path: String
    let size: Int
    let thumbnail: String
    let tn_height: Int
    let tn_width: Int
    let width: Int
}
