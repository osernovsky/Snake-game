//
//  GridManager.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 30.12.2024.
//

import UIKit

class GridManager {
    
    // MARK: Переменные класса
    
    private var grid: [[UIView]] = []
    
    let columns: Int = gameConfig.columnsCount
    let rows: Int = gameConfig.rowsCount
    private let cellGap: CGFloat = 1
    private let cellRound: CGFloat = 2
    private let cellFoneColor: UIColor = .init(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
    private let cellSize: CGFloat = gameConfig.cellSize
    
    private weak var parentView: UIView?
    
    // MARK: Инициализатор класса
    
    init(parentView: UIView) {
        
        self.parentView = parentView
        setupGrid()
    }
    
    // MARK: Функция создающая (рисует темные элементы) сетку согласно вычисленным размерам
    
    func setupGrid() {
        guard let parentView = parentView else { return }
        
        for row in 0..<rows {
            var gridRow: [UIView] = []
            for column in 0..<columns {
                let cellFrame = CGRect(x: CGFloat(column + 1) * cellSize + cellGap, y: CGFloat(row + 4) * cellSize + cellGap, width: cellSize - cellGap, height: cellSize - cellGap)
                let cell = UIView(frame: cellFrame)
                cell.backgroundColor = cellFoneColor
                cell.layer.cornerRadius = cellRound
                parentView.addSubview(cell)
                gridRow.append(cell)
            }
            grid.append(gridRow)
        }
    }
    
    // MARK: Функция выводящая игровые элементы
    
    func drawCell(x: Int, y: Int, shape: ShapeType, color: UIColor, animation: Bool) {
        guard x >= 0, x < columns, y >= 0, y < rows else { return }
        
        let cell = grid[y][x]
        cell.backgroundColor = color
        
        if shape == .circle {
            cell.layer.cornerRadius = cellSize / 2
        } else {
            cell.layer.cornerRadius = 1
        }
        
        if animation {
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                cell.transform = .identity
            }
        }
        
    }
    
    // MARK: Функция стирающая игровые элементы
    
    func removeCell(x: Int, y: Int, animation: Bool) {
        guard x >= 0, x < columns, y >= 0, y < rows else { return }
        
        let cell = grid[y][x]
        
        cell.backgroundColor = cellFoneColor
        cell.layer.cornerRadius = cellRound
    }
    
    // MARK: Функция очищающая все игровые элементы с сетки
    
    func clearGrid() {
        grid.forEach { row in
            row.forEach { cell in
                cell.backgroundColor = cellFoneColor
                cell.layer.cornerRadius = cellRound
            }
        }
    }
}
