//
//  AudioControlView.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

enum AudioStatus: String {
    case play
    case pause

    var image: UIImage {
        switch self {
        case .play:
            return UIImage(named: "pause_player_icon") ?? UIImage()
        case .pause:
            return UIImage(named: "audio_player_icon") ?? UIImage()
        }
    }
}

enum TimeControl: Int {
    case five = 5
    case ten = 10
    case thirty = 30
}

protocol AudioControlViewDelegate: AnyObject {
    func didTapBackward(view: AudioControlView, status: AudioStatus)
    func didTapForward(view: AudioControlView, status: AudioStatus)
    func didTapPlay(view: AudioControlView)
    func didTapPause(view: AudioControlView)
}

class AudioControlView: BaseView {

    @IBOutlet weak var playOrPauseImageView: UIImageView!
    @IBOutlet weak var forwardTimeLabel: UILabel!
    @IBOutlet weak var backwardTimeLabel: UILabel!

    private lazy var status: AudioStatus = .pause
    private var timeControl: TimeControl = .five

    weak var delegate: AudioControlViewDelegate?

    override func initView() {
        super.initView()
        setIconPauseOrPlay()
    }

    func setTimeControl(with time: TimeControl) {
        self.timeControl = time
        self.forwardTimeLabel.text = String(time.rawValue)
        self.backwardTimeLabel.text = String(time.rawValue)
    }

    @IBAction func backwardAction(_ sender: Any) {
        delegate?.didTapBackward(view: self, status: status)
    }

    @IBAction func playOrPauseAction(_ sender: Any) {
        toggleAudioAction()
        if self.status == .play {
            delegate?.didTapPlay(view: self)
        } else {
            delegate?.didTapPause(view: self)
        }
        setIconPauseOrPlay()
    }

    @IBAction func forwardAction(_ sender: Any) {
        delegate?.didTapForward(view: self, status: status)
    }

    private func toggleAudioAction() {
        self.status = self.status == .pause ? .play : .pause
    }

    private func setIconPauseOrPlay() {
        playOrPauseImageView.image = status.image
    }
}
