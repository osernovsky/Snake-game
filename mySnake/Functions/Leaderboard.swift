//
//  Leaderboard.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 08.01.2025.
//

import Foundation

// MARK: Структура игрока в таблице лидеров

struct Player: Codable, Comparable {
    let name: String
    let score: Int
    
    static func < (lhs: Player, rhs: Player) -> Bool { // Условие для Comparable
        lhs.score < rhs.score
    }
}

// MARK: Класс таблицы лидеров со всем функционалом

class Leaderboard {
    
    private var topPlayers: [Player] = []
    private var maxPlayers: Int = 5
    private static let storageKey: String = "LeaderboardData"
    
    // MARK: Функция возвращающая минимальное количество очков для попадания в таблицу
    
    func minimumScore() -> Int {
        topPlayers.min()?.score ?? 0
    }
    
    // MARK: Функция добавляющая игрока и набранных им очков
    
    func addPlayer(name: String, score: Int) {
        let newPlayer = Player(name: name, score: score)
        topPlayers.append(newPlayer)
        topPlayers.sort(by: >)
        if topPlayers.count > maxPlayers {
            topPlayers.removeLast()
        }
        saveLeaderboard()
    }
    
    // MARK: Функция записи таблицы
    
    func saveLeaderboard() {
        
        do {
            let data = try JSONEncoder().encode(topPlayers)
            UserDefaults.standard.set(data, forKey: Leaderboard.storageKey)
        } catch {
            print("Ошибка записи данных: \(error)")
        }
    }
    
    // MARK: Функция загрузки таблицы
    
    func loadLeaderboard() {
        
        guard let data = UserDefaults.standard.data(forKey: Leaderboard.storageKey) else {
            temporaryLeaderboard()
            saveLeaderboard()
            return
        }
        
        do {
            topPlayers = try JSONDecoder().decode([Player].self, from: data)
        } catch {
            print("Ошибка загрузки данных: \(error)")
        }
    }
    
    // MARK: Функция удаления таблицы из памяти телефона
    
    func deleteLeaderboard() {
        UserDefaults.standard.removeObject(forKey: Leaderboard.storageKey)
        topPlayers.removeAll()
    }
    
    // MARK: Функция заполнения временными лидерами
    
    func temporaryLeaderboard() {
        for i in 1...maxPlayers {
            let name = "\(i) игрок"
            let score = (maxPlayers * 100) - (i - 1) * 100
            addPlayer(name: name, score: score)
        }
    }
    
    // MARK: Функция получения данных конкретного места
    
    func getPlayer(at position: Int) -> Player? {
        guard position > 0 && position <= topPlayers.count else { return nil }
        return topPlayers[position - 1]
    }
}

var leaderboard = Leaderboard()

