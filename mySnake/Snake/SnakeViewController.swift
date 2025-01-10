//
//  SnakeViewController.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 30.12.2024.
//

import UIKit

class SnakeViewController: UIViewController {
    
    weak var delegate: GameOverAlertDelegate?
    
    @IBOutlet var scoreTextField: UILabel!
    @IBOutlet var levelTextField: UILabel!
    @IBOutlet var pauseButton: UIButton!
    
    private var gridManager: GridManager?    
    private var moveTimer: Timer?
    
    // MARK: Функция инициализации игровой сцены
    
    override func viewDidLoad(){
        
        // MARK: Запуск игры при загрузке экрана
        
        super.viewDidLoad()
        view.backgroundColor = .black
        gridManager = GridManager(parentView: self.view)
        
        // Акцтивация функции обработки свайпов
        setupSwipeGestures()
        
        // Запускаем игру
        if gameConfig.infiniteMode {
            levelTextField.text = "Бесконечная игра"
        } else {
            levelTextField.text = "Уровень \(gameConfig.currentLevel)"
        }
        apples.removeAll()
        gridManager?.clearGrid()
        snake.initSnake(resetScore: true)
        apples.initApples(excluding: snake.body)
        drawApples()
        
        SoundManager.shared.playMusic(named: "foneMusicTwo")
        
        startGameLoop()
    }
    
    // MARK: Функция настроек по текущий уровень сложности
    
    func levelSetup() {
        levelTextField.text = "Уровень \(gameConfig.currentLevel)"
        let maxElements = gameConfig.rowsCount * gameConfig.columnsCount * 70 / 100
        let levelApples = gameConfig.oneLevelApplesCount * gameConfig.currentLevel
        gameConfig.applesCount = min(maxElements, levelApples)
        apples.removeAll()
        gridManager?.clearGrid()
        snake.initSnake(resetScore: false)
        apples.initApples(excluding: snake.body)
        drawApples()
        startGameLoop()
    }
    
    // MARK: Кнопка выход
    
    @IBAction func endgameButtonPress(_ sender: Any) {
        moveTimer?.invalidate()
        apples.removeAll()
        snake.initSnake(resetScore: true)
        
        SoundManager.shared.stopMusic()
        dismiss(animated: true)
    }
    
    // MARK: Кнопка Пауза-Продолжить
    
    @IBAction func pauseButtonPress(_ sender: Any) {
        if pauseButton.titleLabel?.text == "Пауза" {
            pauseButton.setTitle("Продолжить", for: .normal)
            moveTimer?.invalidate()
            SoundManager.shared.pauseMusic()
        } else {
            pauseButton.setTitle("Пауза", for: .normal)
            startGameLoop()
            SoundManager.shared.resumeMusic()
        }

    }
        
    // MARK: Функция для обработки свайпов
    
    func setupSwipeGestures() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            swipeGesture.direction = direction
            view.addGestureRecognizer(swipeGesture)
        }
    }
    
    // MARK: Функция активации таймера (обновления скорости)
    
    func startGameLoop() {
        moveTimer?.invalidate()
        moveTimer = Timer.scheduledTimer(timeInterval: snake.speed, target: self, selector: #selector(moveSnake), userInfo: nil, repeats: true)
    }
    
    // MARK: Функция движения змеи (шаг движения) + проверки на проигрыш и выигрыш
    
    @objc func moveSnake() {

        snake.moveSnake()
        updateGameDisplay()
        
        if snake.isGameOver {
            
            moveTimer?.invalidate() // Останавливаем таймер
            
            SoundManager.shared.stopMusic()
            SoundManager.shared.playSound(named: "endGameTwo")
            
            if snake.score > leaderboard.minimumScore() {
                showGameOverAlertHighScore() // Показываем сообщение с запрашиванием имени
            } else {
                showGameOverAlert() // Показываем сообщение о конце игры
            }
        }
        
        if snake.isGameWin {
            
            moveTimer?.invalidate() // Останавливаем таймер
            showGameWinAlert() // Показываем сообщение о победе
        }
    }
    
    // MARK: Фуенкция рисования всех яблок перез началом игры
    
    func drawApples() {
        for apple in apples.apples {
            gridManager?.drawCell(x: apple.coordinates.x, y: apple.coordinates.y, shape: .circle, color: appleColor(type: apple.type), animation: true)
        }
        
    }
    
    // MARK: Функция обновления экрана - стирается хвост или добавлятся яблоко
    
    func updateGameDisplay() {
        
        if snake.tail != nil {
            // Простое движение, стираем хвост
            gridManager?.removeCell(x: snake.tail!.x, y: snake.tail!.y, animation: false)
        } else {
            SoundManager.shared.playSound(named: "chpokTwo")
            
            // Проверяем, можно ли добавить яблок
            
            let all = snake.length + apples.count()
            let maxElements = gameConfig.rowsCount * gameConfig.columnsCount * 70 / 100
            let canAddApple = all < maxElements
            
            // Съели яблоко, добавляем новое если режим бесконечный
    
            if gameConfig.infiniteMode && canAddApple {
                apples.addApple(excluding: snake.body)
                let lastApple = apples.getLastApple()
                gridManager?.drawCell(x: lastApple!.coordinates.x, y: lastApple!.coordinates.y, shape: .circle, color: appleColor(type: lastApple!.type), animation: true)
            }
            
            // Обновляем скорость змеи, если съели яблоко
            startGameLoop()
        }
        
        // Рисуем новую голову
        gridManager?.drawCell(x: snake.body[0].x, y: snake.body[0].y, shape: .square, color: snake.color, animation: true)

        // Обновляем текстовые поля - счёт
        scoreTextField.text = "Набрано очков: \(snake.score)"
    }
    
    // MARK: Функция окна конец иры, проигрыш
    
    func showGameOverAlert() {
        
        let alert = UIAlertController(title: "Игра окончена!", message: "Вы проиграли, попробуйте снова.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Выход", style: .default, handler: { _ in self.exitGameScene()
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Функция окна конец иры, проигрыш попадание в турнирную таблицу
    
    func showGameOverAlertHighScore() {
        
        let alert = UIAlertController(title: "Невероятный финал!", message: "Вы достойно проиграли и ваше имя достойно попасть в таблицу лучших!", preferredStyle: .alert)
//        alert.addTextField { textField in textField.placeholder = "Введите свое имя" textField.autocapitalizationType = .words }
        
        alert.addTextField { textField in
            textField.placeholder = "Введите свое имя"
            textField.autocapitalizationType = .words  // Автозаглавная первая буква каждого слова
            
            // Устанавливаем делегата для ограничения длины текста
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notification in
                if let text = textField.text, text.count > 10 {
                    textField.text = String(text.prefix(10)) // Ограничение длины текста до 10 символов
                }
            }
        }
        
        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: {_ in
            if let playerName = alert.textFields?.first?.text, !playerName.isEmpty {
                leaderboard.addPlayer(name: playerName, score: snake.score)
            } else {
                leaderboard.addPlayer(name: "Anonymous", score: snake.score)
            }
            self.exitGameScene()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Функция выигрыша на текущем уровне, уровень увеличивается, игра перезапускается
    
    func showGameWinAlert() {
        let alert = UIAlertController(title: "Вы выграли!", message: "Невероятная победа, уровень пройден, приготовтесь к следующему!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Следующий уровень", style: .default, handler: { _ in self.levelSetup()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Функция закрытия сцены с игрой
    
    func exitGameScene() {
        apples.removeAll()
        snake.initSnake(resetScore: true)
        self.dismiss(animated: true)
        self.delegate?.refreshChempions()
    }
    
    // MARK: Функция обработки свайпов, для изменения направления
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
        case .up:
            if snake.direction != .down {
                snake.direction = .up
            }
        case .down:
            if snake.direction != .up {
                snake.direction = .down
            }
        case .left:
            if snake.direction != .right {
                snake.direction = .left
            }
        case .right:
            if snake.direction != .left {
                snake.direction = .right
            }
        default:
            break
        }
    }
}
