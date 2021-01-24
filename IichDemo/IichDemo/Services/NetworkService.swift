//
//  NetworkService.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 24.01.2021.
//

import Foundation

class NetworkService {
    private init() {}
    static let sharedInstance = NetworkService()

    func requestAllBoards(completion: @escaping (Result<Boards, Error>) -> Void) {
        if let url = URL(string: "https://2ch.hk/makaba/mobile.fcgi?task=get_boards") {
            URLSession.shared.dataTask(with: url) { data, _, error in

                if error != nil {
                    completion(.failure(error!))
                    return
                }

                if let data = data {
                    let boards = try! JSONDecoder().decode(Boards.self, from: data)

                    completion(.success(boards))
                }
            }.resume()
        }
    }

    func requestBoardInfo(boardKey: String, completion: @escaping (Result<BoardInfo, Error>) -> Void) {
        if let url = URL(string: "https://2ch.hk/\(boardKey)/index.json") {
            URLSession.shared.dataTask(with: url) { data, _, error in

                if error != nil {
                    completion(.failure(error!))
                    return
                }

                if let data = data {
                    let boardInfo = try! JSONDecoder().decode(BoardInfo.self, from: data)
                    completion(.success(boardInfo))
                }
            }
        }
    }
}
