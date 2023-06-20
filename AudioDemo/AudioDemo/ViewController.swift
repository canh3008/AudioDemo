//
//  ViewController.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var playerAudioControlView: PlayerAudioControlView!
    override func viewDidLoad() {
        super.viewDidLoad()
        playerAudioControlView.datasource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerAudioControlView.reloadData()
    }

}

extension ViewController: PlayerAudioControlViewDataSource {
    func timeControl(view: PlayerAudioControlView) -> TimeControl {
        return .thirty
    }

    func totalSecondsAudio(view: PlayerAudioControlView) -> Int {
        return 200
    }


}

