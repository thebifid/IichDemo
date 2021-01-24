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
    
    var updateTableViewHandler: (() -> ())?
    
    // MARK: - Private Properties

    // MARK: - Public Properties

    var favBoards: [Desks] = []
    var fetchedBoards: Boards = Boards()

    // MARK: - Public Methods

    func saveDesk(withTitle title: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        guard let entity = NSEntityDescription.entity(forEntityName: "Desks", in: context) else { return }

        let deskObject = Desks(entity: entity, insertInto: context)

        deskObject.title = title
        appDelegate.saveContext { [weak self] result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case .success:
                self?.favBoards.insert(deskObject, at: self!.favBoards.count)
            }
        }
    }

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

    func deleteDesk(objectToDelete object: Desks) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.delete(object)
        appDelegate.saveContext { _ in }
    }

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
}
