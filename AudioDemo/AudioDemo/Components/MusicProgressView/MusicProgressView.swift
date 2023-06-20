//
//  MusicProgressView.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

class MusicProgressView: BaseView {

    @IBOutlet private weak var remainingTimeLabel: UILabel!
    @IBOutlet private weak var elapsedTimeLabel: UILabel!
    @IBOutlet private weak var progressView: ProgressView!

    private var remainingSecondTimes: Int = 0 {
        didSet {
            remainingTimeLabel.text = getTimeString(seconds: remainingSecondTimes)
        }
    }

    var totalSecondTimes: Int?

    var elapsedSecondTimes: Int = 0 {
        didSet {
            elapsedTimeLabel.text = getTimeString(seconds: elapsedSecondTimes)
            setRatioProgress()
            guard let totalSecondTimes = totalSecondTimes else {
                return
            }
            remainingSecondTimes = totalSecondTimes - elapsedSecondTimes
        }
    }

    override func initView() {
        super.initView()

    }

    private func setRatioProgress() {
        guard let totalTime = self.totalSecondTimes else {
            return
        }
        let ratio: Float = Float(self.elapsedSecondTimes) / Float(totalTime)
        guard ratio <= 1, ratio >= 0 else {
            return
        }
        self.progressView.progress = ratio
    }

    private func getTimeString(seconds: Int) -> String {
        return secondsToTimePlayer(seconds).getTimerString()
    }

    private func secondsToTimePlayer(_ seconds: Int) -> TimePlayer {
        return TimePlayer(hours: TimeValue(value: seconds / 3600),
                          minutes: TimeValue(value: (seconds % 3600) / 60),
                          seconds: TimeValue(value: (seconds % 3600) % 60))
    }
}
