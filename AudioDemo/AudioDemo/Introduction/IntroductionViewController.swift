//
//  IntroductionViewController.swift
//  AudioDemo
//
//  Created by Duc Canh on 17/07/2023.
//

import UIKit

class IntroductionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedAudio(_ sender: Any) {
        let audioVC = AudioViewController()
        navigationController?.pushViewController(audioVC, animated: false)
    }
}
