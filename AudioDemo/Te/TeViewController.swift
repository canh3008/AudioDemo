//
//  TeViewController.swift
//  AudioDemo
//
//  Created by Duc Canh on 15/07/2023.
//

import UIKit

class TeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func tap() {
        let audioVC = AudioViewController()
        navigationController?.pushViewController(audioVC, animated: true)
    }

}
