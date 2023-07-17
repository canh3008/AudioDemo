//
//  PlayerAudioControlViewModel.swift
//  AudioDemo
//
//  Created by Duc Canh on 15/07/2023.
//

import Foundation
import AVFoundation

class PlayerAudioControlViewModel {

    private var audioLengthSamples: AVAudioFramePosition = 0

    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let timeEffect = AVAudioUnitTimePitch()

    private var isPlayerReady = false
    private var needsFileSchedule = true

    private var audioSampleRate: Double = 0
    private var audioLengthSeconds: Double = 0
    private var seekFrame: AVAudioFramePosition = 0
    private var currentPosition: AVAudioFramePosition = 0

    private var audioFile: AVAudioFile?
    private var displayLink: CADisplayLink?

    var totalSecondsPlayer: ((Double) -> Void)?
    var currentTime: ((Double) -> Void)?

    private var currentFrame: AVAudioFramePosition {
        guard let lastRenderTime = player.lastRenderTime,
              let playerTime = player.playerTime(forNodeTime: lastRenderTime) else {
            return 0
        }
        return playerTime.sampleTime
    }

    func setupAudio(file name: String) {
        var nameFile = name
        if nameFile.contains(".mp3") {
            nameFile = nameFile.replacingOccurrences(of: ".mp3", with: "")
        }
        guard let fileUrl = Bundle.main.url(forResource: nameFile, withExtension: "mp3") else {
            return
        }

        do {
            let file = try AVAudioFile(forReading: fileUrl)
            let format = file.processingFormat
            audioLengthSamples = file.length
            audioSampleRate = format.sampleRate
            audioLengthSeconds = Double(audioLengthSamples) / audioSampleRate
            totalSecondsPlayer?(audioLengthSeconds)
            audioFile = file
            configureEngine(with: format)
        } catch {
            fatalError("Error reading the audio file: \(error.localizedDescription)")
        }
    }

    func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplay))
        displayLink?.add(to: .current, forMode: .default)
        displayLink?.isPaused = true
    }

    @objc func updateDisplay() {
        currentPosition = currentFrame + seekFrame
        currentPosition = max(currentPosition, 0)
        currentPosition = min(currentPosition, audioLengthSamples)

        if currentPosition >= audioLengthSamples {
            player.stop()
            seekFrame = 0
            currentPosition = 0
            displayLink?.isPaused = true
        }

        let time = Double(currentPosition) / audioSampleRate
        currentTime?(time)
    }

    func seek(time: Int) {
        guard let audioFile = audioFile else {
            return
        }
        let offset = AVAudioFramePosition(Double(time) * audioSampleRate)
        seekFrame = currentPosition + offset
        seekFrame = max(seekFrame, 0)
        seekFrame = min(seekFrame, audioLengthSamples)
        currentPosition = seekFrame

        let wasPlaying = player.isPlaying

        player.stop()

        if currentPosition < audioLengthSamples {
            updateDisplay()
            needsFileSchedule = false

            let frameCount = AVAudioFrameCount(audioLengthSamples - seekFrame)
            player.scheduleSegment(audioFile, startingFrame: seekFrame, frameCount: frameCount, at: nil) { [weak self] in
                self?.needsFileSchedule = true
            }
            if wasPlaying {
                player.play()
            }
        }
    }

    func configureEngine(with format: AVAudioFormat) {
        engine.attach(player)
        engine.attach(timeEffect)

        engine.connect(player, to: timeEffect, format: format)
        engine.connect(timeEffect, to: engine.mainMixerNode, format: format)
        engine.prepare()
        do {
            try engine.start()
            scheduleAudioFile()
            isPlayerReady = true
        } catch {
            fatalError("Error starting the player: \(error.localizedDescription)")
        }
    }

    func scheduleAudioFile() {
        guard let file = audioFile, needsFileSchedule else {
            return
        }
        needsFileSchedule = false
        seekFrame = 0
        player.scheduleFile(file, at: nil) { [weak self] in
            self?.needsFileSchedule = true
        }
    }

    func playOrPause(isPlaying: Bool) {
        displayLink?.isPaused = isPlaying
        if isPlaying {
            player.pause()
        } else {
            if needsFileSchedule {
                scheduleAudioFile()
            }
            player.play()
        }
    }

    func disConnect() {
        displayLink?.invalidate()
        engine.disconnectNodeOutput(player)
        engine.disconnectNodeOutput(timeEffect)
    }


    deinit {
        print("Deinit: ", String(describing: Self.self))
    }
}
