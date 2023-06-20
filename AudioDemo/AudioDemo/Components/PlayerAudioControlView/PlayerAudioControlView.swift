//
//  PlayerAudioControlView.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

protocol PlayerAudioControlViewDataSource: AnyObject {
    func timeControl(view: PlayerAudioControlView) -> TimeControl
    func totalSecondsAudio(view: PlayerAudioControlView) -> Int
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

    private var timeControl: TimeControl?
    private var currentSecond: Int = 0
    private lazy var totalSeconds: Int = 0

    weak var datasource: PlayerAudioControlViewDataSource?

    override func initView() {
        super.initView()
        setupAudioControl()
        setupProgress()
        setImageAudio()
    }

    func reloadData() {
        setupAudioControl()
        setupProgress()
        setImageAudio()
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
        guard let totalTimes = datasource?.totalSecondsAudio(view: self) else {
            return
        }
        self.totalSeconds = totalTimes
        progressView.totalSecondTimes = self.totalSeconds
        progressView.elapsedSecondTimes = 0
    }

    private func setImageAudio() {
        let image = datasource?.imageAudio()
        audioImageView.isHidden = image == nil
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

        progressView.elapsedSecondTimes = currentSecond
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
        progressView.elapsedSecondTimes = currentSecond
    }

    func didTapPlay(view: AudioControlView) {

    }

    func didTapPause(view: AudioControlView) {

    }

}
