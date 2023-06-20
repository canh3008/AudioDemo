//
//  BaseView.swift
//  AudioDemo
//
//  Created by Duc Canh on 19/06/2023.
//

import UIKit

class BaseView: UIView {

    @IBOutlet private weak var commonView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    func initView() {
        let loadView = loadViewFromNib()
        commonView = loadView
        addSubview(commonView)
        commonView.translatesAutoresizingMaskIntoConstraints = false
        [commonView.topAnchor.constraint(equalTo: self.topAnchor),
         commonView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
         commonView.leftAnchor.constraint(equalTo: self.leftAnchor),
         commonView.rightAnchor.constraint(equalTo: self.rightAnchor)].forEach { constraint in
            constraint.isActive = true
        }
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView ?? UIView()
    }
}
