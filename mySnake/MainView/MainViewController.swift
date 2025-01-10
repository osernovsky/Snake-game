//
//  ViewController.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 30.12.2024.
//

import UIKit

class ViewController: UIViewController, GameOverAlertDelegate {
    
    @IBOutlet private var easyModeSwitch: UISwitch!
    @IBOutlet private var speedModeSwitch: UISwitch!
    @IBOutlet private var infiniteModeSwitch: UISwitch!
    @IBOutlet private var applesCount: UISlider!
    
    // Чемпионы
    
    @IBOutlet private var firstPlace: UILabel!
    @IBOutlet private var secondPlace: UILabel!
    @IBOutlet private var thirdPlace: UILabel!
    @IBOutlet private var fourPlace: UILabel!
    @IBOutlet private var fivePlace: UILabel!
    
    // MARK: Функция инициализации главношго экрана
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Задаем количество и размеры ячеек игрового поля
        let result = divideScreenFunction(maxCells: gameConfig.filedMaxSize)
        gameConfig.columnsCount = result.columns - 2
        gameConfig.rowsCount = result.rows - 8
        gameConfig.cellSize = result.cellsize
        
        // Обновляем чемпионов
        loadChempions()
        
    }

    // MARK: Функция кнопки запуска игры
    
    @IBAction func startGameButtonTapped(_ sender: Any) {
        
        // Задаем режим игры согласно настройкам игрока
        
        if easyModeSwitch.isOn {
            gameConfig.easyMode = true
        } else {
            gameConfig.easyMode = false
        }
        if speedModeSwitch.isOn {
            gameConfig.speedMode = true
        } else {
            gameConfig.speedMode = false
        }
        if infiniteModeSwitch.isOn {
            gameConfig.infiniteMode = true
        } else {
            gameConfig.infiniteMode = false
        }
        
        gameConfig.currentLevel = 1 // При запуске игровой сцены уровень всегда первый
        
        // Установка первоначального количества яблок в зависимости от выбора типа игры
        
        if gameConfig.infiniteMode {
            // Задаем макцимальное количество яблок на экране для бесконечной игры
            let maxApplesCount = gameConfig.rowsCount * gameConfig.columnsCount * 70 / 100
            gameConfig.applesCount = maxApplesCount * Int(applesCount.value) / 100
        } else {
            gameConfig.applesCount = gameConfig.oneLevelApplesCount
        }
        
        
        // Запускаем сцену с игрой
        
        let snakeStoryboard = UIStoryboard(name: "SnakeViewController", bundle: nil)
        let snakeViewController = snakeStoryboard.instantiateViewController(withIdentifier: "SnakeViewController") as! SnakeViewController
        snakeViewController.modalPresentationStyle = .fullScreen
        snakeViewController.delegate = self
        present(snakeViewController, animated: true)
    }
    
    func loadChempions() {
        
        let dots = "........"
        
        // Загружаем данные лидеров
        leaderboard.loadLeaderboard()
        let first = leaderboard.getPlayer(at: 1) ?? Player(name: "none", score: 0)
        let second = leaderboard.getPlayer(at: 2) ?? Player(name: "none", score: 0)
        let third = leaderboard.getPlayer(at: 3) ?? Player(name: "none", score: 0)
        let four = leaderboard.getPlayer(at: 4) ?? Player(name: "none", score: 0)
        let five = leaderboard.getPlayer(at: 5) ?? Player(name: "none", score: 0)
        
        firstPlace.text = "\(first.name)\(dots)\(first.score) очков"
        secondPlace.text = "\(second.name)\(dots)\(second.score) очков"
        thirdPlace.text = "\(third.name)\(dots)\(third.score) очков"
        fourPlace.text = "\(four.name)\(dots)\(four.score) очков"
        fivePlace.text = "\(five.name)\(dots)\(five.score) очков"
    }
    
    func refreshChempions() {
        
        let dots = "........"
        
        let first = leaderboard.getPlayer(at: 1) ?? Player(name: "none", score: 0)
        let second = leaderboard.getPlayer(at: 2) ?? Player(name: "none", score: 0)
        let third = leaderboard.getPlayer(at: 3) ?? Player(name: "none", score: 0)
        let four = leaderboard.getPlayer(at: 4) ?? Player(name: "none", score: 0)
        let five = leaderboard.getPlayer(at: 5) ?? Player(name: "none", score: 0)
        
        firstPlace.text = "\(first.name)\(dots)\(first.score) очков"
        secondPlace.text = "\(second.name)\(dots)\(second.score) очков"
        thirdPlace.text = "\(third.name)\(dots)\(third.score) очков"
        fourPlace.text = "\(four.name)\(dots)\(four.score) очков"
        fivePlace.text = "\(five.name)\(dots)\(five.score) очков"
    }

}

