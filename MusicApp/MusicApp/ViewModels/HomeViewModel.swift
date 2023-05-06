//
//  HomeViewModel.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/16/23.
//

import Foundation

protocol HomeDelegate {
    func bindData()
}

class HomeViewModel {
    var delegate: HomeDelegate?
        var data: RecommendedGenres? {
            didSet {
                delegate?.bindData()
            }
        }
    var data1: Recommendations? {
        didSet {
            delegate?.bindData()
        }
    }
    var data2: FeaturePlaylist? {
        didSet {
            delegate?.bindData()
        }
    }
    var data3: NewReleases? {
        didSet {
            delegate?.bindData()
        }
    }
    
    func getData() {
        NetworkManager.shared.getRecommendedGenres { [weak self] data in
            let genres = data.genres
            var seeds = Set<String>()
            while seeds.count < 5 {
                if let random = genres?.randomElement() {
                    seeds.insert(random)
                }
            }
            NetworkManager.shared.getRecommendations(genres: seeds) { [weak self] data1 in
                guard let self = self else { return }
                self.data1 = data1
            }

        }
        
        NetworkManager.shared.getFeaturePlaylist { [weak self] data2 in
            guard let self = self else { return }
            self.data2 = data2

        }
        
        NetworkManager.shared.getNewReleases { [weak self] data3 in
            guard let self = self else { return }
            self.data3 = data3
        }
    }
}
