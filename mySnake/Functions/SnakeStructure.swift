//
//  SnakeStructure.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 31.12.2024.
//
import UIKit

// MARK: Направления движения змеи

enum Direction: CaseIterable {
    case left
    case right
    case up
    case down
    
    static var random: Direction {
        return Self.allCases.randomElement()!
    }
}

// MARK: Структура змеи

struct Snake {
    var body: [Coordinates] = []
    var tail: Coordinates?
    var direction: Direction = Direction.random
    var color: UIColor = .orange
    var speed: Double = gameConfig.initialSpeed
    var score: Int = 0
    var isGameOver: Bool = false
    var isGameWin: Bool = false
    var length: Int { body.count }
    
    // MARK: Инициализация змеи (очистка, размещение первого элемента в центре и случаное направление)
    
    mutating func initSnake(resetScore: Bool) {
        body.removeAll()
        tail = nil // ФЛАГ ГОВОРЯЩИЙ О ТОМ, ЧТО ХВОСТ НАДО ОСТАВИТЬ -> СЪЕДЕНО ЯБЛОКО
        body.append(Coordinates(x: gameConfig.columnsCount / 2, y: gameConfig.rowsCount / 2))
        direction = Direction.random
        if resetScore { score = 0 } else { score += 100 }
        speed = gameConfig.initialSpeed
        isGameOver = false
        isGameWin = false
    }
    
    // MARK: Главная функция движения змеи
    
    mutating func moveSnake() {
        
        let snakeHeadMove = directionCoordinates(direction)
        var newHead = Coordinates(x: body[0].x + snakeHeadMove.x, y: body[0].y + snakeHeadMove.y)
        
        if newHead.x < 0 || newHead.x >= gameConfig.columnsCount || newHead.y < 0 || newHead.y >= gameConfig.rowsCount {
            if !gameConfig.easyMode {
                isGameOver = true
                return
            } else {
                var newX = newHead.x
                var newY = newHead.y
                if newX < 0 { newX = gameConfig.columnsCount - 1 }
                if newX >= gameConfig.columnsCount { newX = 0 }
                if newY < 0 { newY = gameConfig.rowsCount - 1 }
                if newY >= gameConfig.rowsCount { newY = 0 }                
                newHead = Coordinates(x: newX, y: newY)
            }
        }
        
        if body.contains(newHead) {
            isGameOver = true
            return
        }
        
        body.insert(newHead, at: 0)
        
        if let appleIndex = apples.apples.firstIndex(where: {$0.coordinates == newHead}) {
            let apple = apples.apples[appleIndex]
            apples.apples.remove(at: appleIndex)
            score += gameConfig.scoreStep
            speed -= appleSpeed(type: apple.type)
            
            if speed < gameConfig.highSpeed {
                speed = gameConfig.highSpeed
            } else if speed > gameConfig.lowSpeed {
                speed = gameConfig.lowSpeed
            }
            
            tail = nil // ФЛАГ ХВОСТ ОСТАВИТЬ -> СЪЕДЕНО ЯБЛОКО
            
        } else {
            tail = body.removeLast()
        }
        
        if apples.apples.isEmpty {
            isGameWin = true // Яблоки на уровне кончились, победа
            gameConfig.currentLevel += 1
        }
    }
}

// MARK: Функция преобразования направления в смещение координат

func directionCoordinates(_ direction: Direction) -> Coordinates {
    
    switch direction {
    case .left:
        return Coordinates(x: -1, y: 0)
    case .right:
        return Coordinates(x: 1, y: 0)
    case .up:
        return Coordinates(x: 0, y: -1)
    case .down:
        return Coordinates(x: 0, y: 1)
    }
}

var snake = Snake()
