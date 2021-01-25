//
//  HomeScreenViewModel.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 23.01.2021.
//

import CoreData
import UIKit

class HomeScreenViewModel {
    // MARK: - Handlers

    var updateTableViewHandler: (() -> Void)?

    // MARK: - Private Properties

    // MARK: - Public Properties

    var favBoards: [Desks] = []
    var fetchedBoards: Boards = Boards()

    // MARK: - Public Methods

    /// CoreData
    func saveDesk(withBoardKey boardKey: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        if checkDuplicate(boardKey: boardKey) {
            let error = NSError(domain: "", code: 100, userInfo: [NSLocalizedDescriptionKey: "Already in"])
            completion(.failure(error))
            return
        }

        requestBoardInfo(boardKey: boardKey) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(boardInfo):

                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext

                    guard let entity = NSEntityDescription.entity(forEntityName: "Desks", in: context) else { return }
                    let deskObject = Desks(entity: entity, insertInto: context)
                    deskObject.boardKey = boardInfo.Board
                    deskObject.boardName = boardInfo.BoardName
                    appDelegate.saveContext { [weak self] result in
                        switch result {
                        case let .failure(error):
                            completion(.failure(error))
                        case .success:
                            self?.favBoards.insert(deskObject, at: self!.favBoards.count)
                            completion(.success(()))
                        }
                    }
                }
            }
        }
    }

    /// CoreData
    func fetchDesk() {
        let fetchRequest: NSFetchRequest<Desks> = Desks.fetchRequest()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        do {
            favBoards = try context.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Cant load data from db \(error.localizedDescription)")
        }
    }

    /// CoreData
    func deleteDesk(objectToDelete object: Desks) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(object)
        appDelegate.saveContext { _ in }
    }

    /// API
    func requestBoards() {
        NetworkService.sharedInstance.requestAllBoards { [weak self] result in
            switch result {
            case let .failure(error):
                print("failed to load boards, \(error.localizedDescription)")
            case let .success(boards):
                self?.fetchedBoards = boards
                self?.updateTableViewHandler?()
            }
        }
    }

    // MARK: - Private Methods

    private func checkDuplicate(boardKey: String) -> Bool {
        var isDuplicated: Bool = false
        favBoards.forEach { desk in
            if desk.boardKey == boardKey {
                isDuplicated = true
            }
        }
        return isDuplicated
    }

    private func requestBoardInfo(boardKey: String, completion: @escaping ((Result<BoardInfo, Error>) -> Void)) {
        NetworkService.sharedInstance.requestBoardInfo(boardKey: boardKey) { result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
                completion(.failure(error))
            case let .success(boardInfo):
                print(boardInfo.Board, boardInfo.BoardName)
                completion(.success(boardInfo))
            }
        }
    }
}
