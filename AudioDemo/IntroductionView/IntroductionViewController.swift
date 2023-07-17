//
//  IntroductionViewController.swift
//  AudioDemo
//
//  Created by Duc Canh on 15/07/2023.
//

import UIKit

class IntroductionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tap(_ sender: Any) {
        let audioVC = AudioViewController()
        navigationController?.pushViewController(audioVC, animated: true)
    }

}
