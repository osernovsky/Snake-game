//
//  DivideScreenFunction.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 30.12.2024.
//

import UIKit

// MARK: Функция подсчета рзмера игрового поля в зависимости от размера экрнана устройства

func divideScreenFunction(maxCells: Int) -> (columns: Int, rows: Int, cellsize: CGFloat) {
    let width = Int(UIScreen.main.bounds.width)
    let height = Int(UIScreen.main.bounds.height)
    
    let maxDimension = width > height ? width : height
    let cellSize = maxDimension / maxCells
    
    guard cellSize > 0 else { fatalError("Cell size must be greater than zero") }
    
    let columns = width / cellSize
    let rows = height / cellSize
    
    return (columns, rows, CGFloat(cellSize))
    
}
