//
//  LyricsListView.swift
//  AudioDemo
//
//  Created by Duc Canh on 17/07/2023.
//

import Foundation
import UIKit

class LyricsListView: BaseView {

    @IBOutlet private weak var tableView: UITableView!

    private var rawLyrics = [
        "[00:13]Not sure if you know this",
        "[00:17]But when we first met",
        "[00:20]I got so nervous I couldn't speak",
        "[00:26]In that very moment",
        "[00:29]I found the one and",
        "[00:33]My life had found its missing piece",
        "[00:39]So as long as I live I love you",
        "[00:44]Will have and hold you",
        "[00:47]You look so beautiful in white",
        "[00:52]And from now 'til my very last breath",
        "[00:56]This day I'll cherish",
        "[00:59]You look so beautiful in white",
        "[01:04]Tonight",
        "[01:12]What we have is timeless",
        "[01:15]My love is endless",
        "[01:18]And with this ring I",
        "[01:21]Say to the world",
        "[01:24]You're my every reason",
        "[01:28]You're all that I believe in",
        "[01:31]With all my heart I mean every word",
        "[01:37]So as long as I live I love you",
        "[01:42]Will haven and hold you",
        "[01:45]You look so beautiful in white",
        "[01:50]And from now 'til my very last breath",
        "[01:54]This day I'll cherish",
        "[01:58]You look so beautiful in white",
        "[02:03]Tonight",
        "[02:11]You look so beautiful in white, yeah yeah",
        "[02:21]Na na na na",
        "[02:24]So beautiful in white",
        "[02:29]Tonight",
        "[02:31]And if a daughter is what our future holds",
        "[02:35]I hope she has your eyes",
        "[02:39]Finds love like you and I did",
        "[02:43]Yeah, and if she falls in love, we'll let her go",
        "[02:48]I'll walk her down the aisle",
        "[02:51]She'll look so beautiful in white, yeah yeah",
        "[03:01]So beautiful in white",
        "[03:06]So as long as I live I love you",
        "[03:10]Will have and hold you",
        "[03:13]You look so beautiful in white",
        "[03:19]And from now 'til my very last breath",
        "[03:23]This day I'll cherish",
        "[03:26]You look so beautiful in white",
        "[03:32]Tonight",
        "[03:37]Na na na na",
        "[03:40]So beautiful in white",
        "[03:44]Tonight"
    ]

    private lazy var lyrics = [Lyric]()
    private lazy var timeStamps = [Int]()
    fileprivate var oldSecond = 0

    var currentSecondsAudio: Int = 0 {
        didSet {
            guard currentSecondsAudio > 0,
                  !timeStamps.isEmpty,
                  currentSecondsAudio > oldSecond else {
                return
            }
            oldSecond = currentSecondsAudio
            guard let index = timeStamps.firstIndex(where: { $0 == currentSecondsAudio }) else {
                return
            }
            lyrics.forEach({ $0.isBlur = false })
            lyrics[index].isBlur = true
            if index > 0 {
                tableView.scrollToRow(at: IndexPath(row: index - 1, section: 0), at: .top, animated: true)
            }
            reloadTableView()
        }
    }
    override func initView() {
        super.initView()
        setupTableView()
        getAllComponentsForLyric()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: DetailLyricTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: DetailLyricTableViewCell.identifier)
    }

    private func getAllComponentsForLyric() {
        let regix = "\\[.*?\\]"
        for lyric in rawLyrics {
            let lyricString = lyric.replacingOccurrences(of: regix, with: "", options: .regularExpression)
            lyrics.append(Lyric(text: lyricString))
            let match = lyric.range(of: regix, options: .regularExpression)
            if let match = match {
                let totalSeconds = getTotalSecond(time: String(lyric[match]))
                timeStamps.append(totalSeconds)
            }
        }
        reloadTableView()
        print("zzzzzzzz time", timeStamps)
    }

    private func getTotalSecond(time string: String) -> Int {
        let minutesAndSeconds = string.trimmingCharacters(in: CharacterSet(charactersIn: "[]")).components(separatedBy: ":")
        guard minutesAndSeconds.count == 2 else {
            return 0
        }
        let minutes = Int(minutesAndSeconds[0]) ?? 0
        let seconds = Int(minutesAndSeconds[1]) ?? 0
        return minutes * 60 + seconds
    }

    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension LyricsListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lyrics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailLyricTableViewCell.identifier, for: indexPath) as? DetailLyricTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: lyrics[indexPath.row])
        return cell
    }

}
