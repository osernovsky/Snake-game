//
//  SoundManager.swift
//  mySnake
//
//  Created by Sergey Dubrovin on 09.01.2025.
//

import AVFoundation
import UIKit

class SoundManager {
    
    static let shared = SoundManager() // Синглтон
    
    private var isPausedBySystem = false // Флаг для отслеживания паузы при сворачивании приложения
    
    private var musicPlayer: AVAudioPlayer! // Плейер фоновой музыки
    private var soundPlayer: AVAudioPlayer! // Плейер съедания яблока
    
    private init() {
        // Подписка на уведомления
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self) // Отписка от уведомлений
    }
    
    // MARK: Функция проигрывания фоновой музыки
    
    func playMusic(named musicName: String, withExtension extensionName: String = "mp3", loop: Bool = true) {
        
        if let musicURL = Bundle.main.url(forResource: musicName, withExtension: extensionName) {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                musicPlayer.prepareToPlay()
                musicPlayer.volume = 0.5
                musicPlayer.numberOfLoops = loop ? -1 : 0
                musicPlayer.play()
            } catch {
                print("Error loading music: \(error)")
            }
        } else {
            print("Error loading music")
        }
        
    }
    
    // MARK: Функция проигрывания звуков
    
    func playSound(named soundName: String, withExtension extensionName: String = "mp3") {
        
        if let soundURL = Bundle.main.url(forResource: soundName, withExtension: extensionName) {
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
                soundPlayer.prepareToPlay()
                soundPlayer.volume = 0.8
                soundPlayer.play()
            } catch {
                print("Error loading music: \(error)")
            }
        } else {
            print("Error loading music")
        }
    }
    
    func stopMusic() {
        if musicPlayer != nil {
            musicPlayer?.stop()
            musicPlayer = nil
        }
    }
    
    func setMusicVolume(_ volume: Float) {
        if volume > 0.0 && volume <= 1.0 {
            musicPlayer?.volume = volume
        }
    }
    
    func setSoundVolume(_ volume: Float) {
        if volume > 0.0 && volume <= 1.0 {
            soundPlayer?.volume = volume
        }
    }
    
    // Пауза музыки
    func pauseMusic() {
        if musicPlayer?.isPlaying == true {
            musicPlayer?.pause()
            print("Фоновая музыка поставлена на паузу")
        }
    }

    // Возобновление музыки
    func resumeMusic() {
        if let player = musicPlayer, !player.isPlaying {
            player.play()
            print("Фоновая музыка возобновлена")
        }
    }
    
    // Обработчик: приложение свернулось
    @objc private func handleAppDidEnterBackground() {
        if musicPlayer?.isPlaying == true {
            isPausedBySystem = true // Устанавливаем флаг, что музыка была приостановлена системой
            pauseMusic()
        }
    }

    // Обработчик: приложение снова активно
    @objc private func handleAppDidBecomeActive() {
        if isPausedBySystem {
            resumeMusic()
            isPausedBySystem = false // Сбрасываем флаг
        }
    }
}
