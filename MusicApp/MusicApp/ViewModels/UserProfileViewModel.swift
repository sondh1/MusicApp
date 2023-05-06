//
//  UserProfileViewModel.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/15/23.
//

import Foundation

protocol ProfileDelegate {
    func bindData()
}

class UserProfileViewModel {
    var delegate: ProfileDelegate?
        var data: UserProfile? {
            didSet {
                delegate?.bindData()
            }
        }
    func getData() {
        NetworkManager.shared.getUserProfile { [weak self] data in
                guard let self = self else { return }
                self.data = data
        }
    }
}
