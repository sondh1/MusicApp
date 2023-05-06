//
//  LibraryChoice.swift
//  MusicApp
//
//  Created by Đặng Hồng Sơn on 01/05/2023.
//

import UIKit

protocol LibraryChoiceDelegate: AnyObject {
    func didTapPlaylist(_ toggleView: LibraryChoice)
    func didTapAlbum(_ toggleView: LibraryChoice)
}

class LibraryChoice: UIView {

    weak var delegate: LibraryChoiceDelegate?
    enum State {
        case playlist
        case album
    }
    
    var state: State = .playlist
    
    private let playlistButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.setTitle("Playlists", for: .normal)
        return btn
    }()
    
    private let albumButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.label, for: .normal)
        btn.setTitle("Albums", for: .normal)
        return btn
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(playlistButton)
        addSubview(albumButton)
        addSubview(indicatorView)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(didTapAlbum), for: .touchUpInside)
    }
    required init(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        albumButton.frame = CGRect(x: playlistButton.frame.maxX, y: 0, width: 100, height: 40)
        layoutIndicator()
        
    }
    private func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(x: 0, y: playlistButton.frame.maxY, width: 100, height: 3)
        case .album:
            indicatorView.frame = CGRect(x: 100, y: playlistButton.frame.maxY, width: 100, height: 3)
        }
    }
    
    @objc private func didTapPlaylist() {
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.didTapPlaylist(self)
    }
    @objc private func didTapAlbum() {
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        delegate?.didTapAlbum(self)
    }
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
