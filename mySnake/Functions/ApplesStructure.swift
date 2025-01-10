//
//  ApplesStructure.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 31.12.2024.
//

import UIKit

// MARK: Тивы яблок

enum AppleType: CaseIterable {
    case normal
    case speedUp
    case slowDown
    
    static var random: AppleType {
        return Self.allCases.randomElement()!
    }
}

// MARK: Структура яблока

struct Apple {
    var coordinates: Coordinates
    var type: AppleType
}

// MARK: Структура массива яблок на поле

struct Apples {
    var apples: [Apple] = []
    
    // MARK: Первоначальная инициализация (генерация) яблок
    
    mutating func initApples(excluding snake: [Coordinates]) {
        
        let maxApples = min (gameConfig.applesCount, gameConfig.rowsCount * gameConfig.columnsCount)
        
        while apples.count < maxApples {
            let randomX = Int.random(in: 0..<gameConfig.columnsCount)
            let randomY = Int.random(in: 0..<gameConfig.rowsCount)
            let newCoordinates = Coordinates(x: randomX, y: randomY)
            let randomType: AppleType
            
            // Здесь идет обработка типа яблок в зависимости от настроек игрока
            
            if gameConfig.speedMode {
                randomType = AppleType.random
            } else {
                randomType = AppleType.normal
            }
                        
            if !snake.contains(newCoordinates) && !apples.contains(where: { $0.coordinates == newCoordinates }) {
                apples.append(Apple(coordinates: newCoordinates, type: randomType))
            }
        }
    }
    
    // MARK: Функция съедания (удаления) яблока
    
    mutating func removeApple(at coordinates: Coordinates) {
        apples.removeAll(where: { $0.coordinates == coordinates })
    }
    
    // MARK: Функция удаления всех яблок
    
    mutating func removeAll() {
        apples.removeAll()
    }
    
    // MARK: Функция добавления одного яблока
    
    mutating func addApple(excluding snake: [Coordinates]) {
        
        var newCoordinates: Coordinates
        let randomType: AppleType
        
        repeat {
            let randomX = Int.random(in: 0..<gameConfig.columnsCount)
            let randomY = Int.random(in: 0..<gameConfig.rowsCount)
            newCoordinates = Coordinates(x: randomX, y: randomY)            
        } while snake.contains(newCoordinates) || apples.contains(where: { $0.coordinates == newCoordinates })
        
        // Здесь идет обработка типа яблок в зависимости от настроек игрока
        
        if gameConfig.speedMode {
            randomType = AppleType.random
        } else {
            randomType = AppleType.normal
        }
        
        apples.append(Apple(coordinates: newCoordinates, type: randomType))
                    
    }
    
    // MARK: Функция получения последнего добавленного яблока для его вывода в игровое поле
    
    func getLastApple() -> Apple? {
        return apples.last
    }
    
    // MARK: Функция количества яблок
    
    func count() -> Int {
        return apples.count
    }
}


var apples = Apples()

// MARK: Функция цвета яблок в зависимости от типа

func appleColor(type: AppleType) -> UIColor {
    switch type {
    case .normal: return .green
    case .slowDown: return .cyan
    case .speedUp: return .red
    }
}

// MARK: Функция изменения скорости змеи от вида съеденного яблока

func appleSpeed(type: AppleType) -> Double {
    switch type {
    case .normal: return 0
    case .slowDown: return -gameConfig.speedStep
    case .speedUp: return gameConfig.speedStep
    }
}
