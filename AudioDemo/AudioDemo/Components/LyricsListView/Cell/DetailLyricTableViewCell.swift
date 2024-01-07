//
//  DetailLyricTableViewCell.swift
//  AudioDemo
//
//  Created by Duc Canh on 17/07/2023.
//

import UIKit

class DetailLyricTableViewCell: UITableViewCell {

    @IBOutlet private weak var lyricLabel: UILabel!

    static let identifier = "DetailLyricTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with lyric: Lyric) {
        lyricLabel.text = lyric.text
        lyricLabel.font = UIFont(name: "Helvetica Neue Medium", size: 24) //UIFont(name: "Helvetica Neue Medium", size: 28) :
        if lyric.isBlur {
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
                self.lyricLabel.font = UIFont(name: "Helvetica Neue Medium", size: 28)
            }, completion: nil)
        }
    }
    
}
