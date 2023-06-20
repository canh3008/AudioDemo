//
//  ProgressView.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

@IBDesignable
class ProgressView: BaseView {

    @IBOutlet private weak var progressView: UIProgressView!

    @IBInspectable var progressColor: UIColor = .link {
        didSet {
            progressView.progressTintColor = progressColor
        }
    }

    @IBInspectable var trackProgressView: UIColor = .clear {
        didSet {
            progressView.trackTintColor = trackProgressView
        }
    }

    var progress: Float = 0.2 {
        didSet {
            progressView.progress = progress
        }
    }

    override func initView() {
        super.initView()
        
    }

}
