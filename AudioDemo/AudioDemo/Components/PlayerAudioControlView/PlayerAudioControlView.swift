//
//  PlayerAudioControlView.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

protocol PlayerAudioControlViewDataSource: AnyObject {
    func timeControl(view: PlayerAudioControlView) -> TimeControl
    func nameAudio(view: PlayerAudioControlView) -> String
}

extension PlayerAudioControlViewDataSource {
    func imageAudio() -> UIImage? {
        return nil
    }
}

class PlayerAudioControlView: BaseView {

    @IBOutlet private weak var audioControlView: AudioControlView!
    @IBOutlet private weak var progressView: MusicProgressView!
    @IBOutlet private weak var audioImageView: UIImageView!
    @IBOutlet private weak var lyricsListView: LyricsListView!

    private var viewModel = PlayerAudioControlViewModel()

    private var timeControl: TimeControl?
    private var currentSecond: Int = 0 {
        didSet {

            self.progressView.elapsedSecondTimes = currentSecond

            guard totalSeconds > 0,
                    currentSecond > 0,
                  currentSecond == totalSeconds else {
                return
            }
            self.audioControlView.status = .pause
        }
    }
    private var totalSeconds: Int = 0

    weak var datasource: PlayerAudioControlViewDataSource?

    override func initView() {
        super.initView()
        setupAudioControl()
        setupProgress()
        setImageAudio()

        lyricsListView.isHidden = false
    }

    func reloadData() {
        setupAudio()
        setupAudioControl()
        setImageAudio()
    }

    private func setupAudio() {
        guard let nameAudio = datasource?.nameAudio(view: self) else {
            return
        }
        bindingData()
        viewModel.setupAudio(file: nameAudio)
        viewModel.setupDisplayLink()
    }

    private func bindingData() {
        viewModel.totalSecondsPlayer = { [weak self] time in
            self?.totalSeconds = Int(time)
            self?.setupProgress()
        }

        viewModel.currentTime = { [weak self] timeCurrent in
            self?.lyricsListView.currentSecondsAudio = Int(timeCurrent)
            self?.currentSecond = Int(timeCurrent)
        }
    }

    private func setupAudioControl() {
        audioControlView.delegate = self
        self.timeControl = datasource?.timeControl(view: self)
        guard let time = self.timeControl else {
            return
        }
        audioControlView.setTimeControl(with: time)
    }

    private func setupProgress() {
        progressView.totalSecondTimes = self.totalSeconds
        progressView.elapsedSecondTimes = 0
    }

    private func setImageAudio() {
        let image = datasource?.imageAudio()
        audioImageView.isHidden = image == nil
    }

    deinit {
        viewModel.disConnect()
        print("Deinit: ", String(describing: Self.self))
    }

}

extension PlayerAudioControlView: AudioControlViewDelegate {

    func didTapBackward(view: AudioControlView, status: AudioStatus) {
        guard let timeControl = self.timeControl, currentSecond > 0 else {
            return
        }
        if currentSecond - timeControl.rawValue < 0 {
            self.currentSecond = 0
        } else {
            currentSecond -= timeControl.rawValue
        }
        viewModel.seek(time: -timeControl.rawValue)
    }

    func didTapForward(view: AudioControlView, status: AudioStatus) {
        guard let timeControl = self.timeControl, currentSecond < totalSeconds else {
            return
        }
        if currentSecond + timeControl.rawValue >= self.totalSeconds {
            currentSecond = self.totalSeconds
        } else {
            currentSecond += timeControl.rawValue
        }
        viewModel.seek(time: timeControl.rawValue)
    }

    func didTapPlay(view: AudioControlView) {
        viewModel.playOrPause(isPlaying: false)
    }

    func didTapPause(view: AudioControlView) {
        viewModel.playOrPause(isPlaying: true)
    }

}
