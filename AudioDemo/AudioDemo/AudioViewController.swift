//
//  AudioViewController.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

class AudioViewController: UIViewController {

    @IBOutlet private weak var playerAudioControlView: PlayerAudioControlView!

    private let viewModel: AudioViewModel = AudioViewModel()
    private var totalTime: Double = 0 {
        didSet {
            DispatchQueue.main.async {
                self.playerAudioControlView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playerAudioControlView.datasource = self
        playerAudioControlView.delegate = self
        viewModel.totalSecondsPlayer = { [weak self] time in
            self?.totalTime = time
        }

        viewModel.currentTime = { [weak self] currentTime in
            self?.playerAudioControlView.currentSecond = Int(currentTime)
        }
        viewModel.setupAudio()
        viewModel.setupDisplayLink()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerAudioControlView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disConnect()
    }

}

extension AudioViewController: PlayerAudioControlViewDataSource {
    func timeControl(view: PlayerAudioControlView) -> TimeControl {
        return .thirty
    }

    func totalSecondsAudio(view: PlayerAudioControlView) -> Int {
        return Int(totalTime)
    }
}

extension AudioViewController: PlayerAudioControlViewDelegate {
    func didTapForward(view: PlayerAudioControlView, seconds: Int) {
        viewModel.seek(time: seconds)
    }

    func didTapBackward(view: PlayerAudioControlView, seconds: Int) {
        viewModel.seek(time: seconds)
    }

    func didTapPlay(view: PlayerAudioControlView) {
        viewModel.playOrPause(isPlaying: false)
    }

    func didTapPause(view: PlayerAudioControlView) {
        viewModel.playOrPause(isPlaying: true)
    }
}

