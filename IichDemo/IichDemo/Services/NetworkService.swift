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
                    do {
                        let boards = try JSONDecoder().decode(Boards.self, from: data)
                        completion(.success(boards))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }

    func requestBoardInfo(boardKey: String, pageNumber: Int = 0, completion: @escaping (Result<BoardListModel, Error>) -> Void) {
        var page: Any = "index"

        if pageNumber != 0 {
            page = pageNumber
        }

        if let url = URL(string: "https://2ch.hk/\(boardKey)/\(page).json") {
            URLSession.shared.dataTask(with: url) { data, _, error in

                if error != nil {
                    completion(.failure(error!))
                    return
                }

                if let data = data {
                    do {
                        let boardInfo = try JSONDecoder().decode(BoardListModel.self, from: data)
                        completion(.success(boardInfo))
                    } catch {
                        completion(.failure(error))
                    }
                }

            }.resume()
        }
    }
}
