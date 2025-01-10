//
//  GameConfig.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 30.12.2024.
//

import UIKit

// MARK: Структура с настройками игры

struct GameConfig {
    
    let filedMaxSize: Int = 35  // Количество ячеек по длинной стороне экрана
    let scoreStep: Int = 10 // Шаг увеличения очков за яблоко
    var currentLevel: Int = 1 // Текущий уровень игры
    let highSpeed: Double = 0.05 // Максимальная скорость игры
    var lowSpeed: Double {max(0.4 - 0.02 * (Double(currentLevel) - 1), highSpeed)} // Вычисляемое значение мин. скорости
    var initialSpeed: Double {0.75 * lowSpeed} // Вычисляемое значение стартовой скорости на уровне
    let speedStep: Double = 0.05 // Шаг изменения скорости от съеденного яблока
    
    var easyMode: Bool = true // Режим без стен
    var speedMode: Bool = true // Режим без изменения скорости
    var infiniteMode: Bool = true // Режим без уровней, бесконечный
    
    var oneLevelApplesCount = 5 //Количество яблок на первом уровне
    var applesCount: Int = 1 // Количество яблок на текущем уровне
    
    // Размеры игрового поля устройства
    
    var columnsCount: Int = 0
    var rowsCount: Int = 0
    var cellSize: CGFloat = 0
}

var gameConfig = GameConfig()

// MARK: Типы игровых элементов на поле

enum ShapeType {
    case square // Змея
    case circle // Яблоко
}

