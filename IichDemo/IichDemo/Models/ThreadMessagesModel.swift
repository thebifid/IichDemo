//
//  ThreadMessagesModel.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 01.02.2021.
//

import Foundation

struct ThreadMessagesModel: Decodable {
    var threads: [Messages]

    init() {
        threads = []
    }
}

struct Messages: Decodable {
    let posts: [Message]
}

struct Message: Decodable {
    let banned: Int
    let closed: Int
    let comment: String
    let date: String
    let email: String
    let endless: Int
    let files: [Attachements]
    let lasthit: Int
    let name: String
    let num: Int
    let number: Int
    let op: Int
    let parent: String
    let posts_count: Int?
    let files_count: Int?
    let sticky: Int
    let subject: String
    let timestamp: Int
    var replies: [Int]?
}

struct Attachements: Decodable {
    let displayname: String?
    let fullname: String?
    let height: Int?
    let name: String?
    let nsfw: Int?
    let path: String?
    let size: Int?
    let thumbnail: String?
    let tn_height: Int?
    let tn_width: Int?
    let width: Int?
}
