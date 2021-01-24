//
//  Bards.swift
//  IichDemo
//
//  Created by Vasiliy Matveev on 24.01.2021.
//

import Foundation

struct Boards: Decodable {
    let Взрослым: [BoardModel]
    let Игры: [BoardModel]
    let Политика: [BoardModel]
    let Пользовательские: [BoardModel]
    let Разное: [BoardModel]
    let Творчество: [BoardModel]
    let Тематика: [BoardModel]

    init() {
        Взрослым = []
        Игры = []
        Политика = []
        Пользовательские = []
        Разное = []
        Творчество = []
        Тематика = []
    }
}

struct BoardModel: Decodable {
    let category: String
    let name: String
    let id: String
}
