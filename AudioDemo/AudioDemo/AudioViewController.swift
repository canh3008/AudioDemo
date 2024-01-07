//
//  AudioViewController.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

class AudioViewController: UIViewController {

    @IBOutlet private weak var playerAudioControlView: PlayerAudioControlView!

    override func viewDidLoad() {
        super.viewDidLoad()
        playerAudioControlView.datasource = self
        self.playerAudioControlView.reloadData()
    }
}

extension AudioViewController: PlayerAudioControlViewDataSource {
    func nameAudio(view: PlayerAudioControlView) -> String {
        return "Beautiful_in_white"
    }

    func timeControl(view: PlayerAudioControlView) -> TimeControl {
        return .thirty
    }
}
