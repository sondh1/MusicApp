//
//  PlaybackPresenter.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/31/23.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var descriptionTitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private var track: AudioTracks?
    private var tracks = [AudioTracks]()
    
    var index = 0
    var currentTrack: AudioTracks? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let player = self.playerQueue, !tracks.isEmpty {
//            let item = player.currentItem
//            let items = player.items()
//            guard let index = items.firstIndex(where: { $0 == item }) else {
//                return nil
//            }
            return tracks[index]
        }
        return nil
    }
    var playerVC: PlayerViewController?
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    func startPlayback(from viewController: UIViewController, track: AudioTracks) {
        guard let url = URL(string: track.preview_url ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.volume = 0.0
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    func startPlayback(from viewController: UIViewController, tracks: [AudioTracks]) {
        self.tracks = tracks
        self.track = nil
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.uri ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playerVC = vc
    }
}
extension PlaybackPresenter: PlayerDataSource {
    var descriptionTitle: String? {
        return currentTrack?.artists?.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images?.first?.url ?? "")
    }
    
    var songName: String? {
        return currentTrack?.name
    }
}
extension PlaybackPresenter: PlayerViewControllerDelegate {
    func pause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    func next() {
            if tracks.isEmpty {
                player?.pause()
            } else {
                index += 1
                if index >= tracks.count {
                    index = 0
                }
                let nextTrack = tracks[index]
                guard let url = URL(string: nextTrack.preview_url ?? "") else { return }
                let playerItem = AVPlayerItem(url: url)
                playerQueue?.removeAllItems()
                playerQueue?.insert(playerItem, after: nil)
                playerVC?.refreshUI()
            }
        }
    
    func back() {
            if tracks.isEmpty {
                player?.pause()
                player?.play()
            } else {
                index -= 1
                if index < 0 {
                    index = tracks.count - 1
                }
                let previousTrack = tracks[index]
                guard let url = URL(string: previousTrack.preview_url ?? "") else { return }
                let playerItem = AVPlayerItem(url: url)
                playerQueue?.removeAllItems()
                playerQueue?.insert(playerItem, after: nil)
                playerVC?.refreshUI()
            }
        }
    
    func slide(_ value: Float) {
        player?.volume = value
    }
    
}
