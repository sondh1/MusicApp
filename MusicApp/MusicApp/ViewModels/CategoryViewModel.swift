//
//  CategoryViewModel.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/29/23.
//

import Foundation

protocol CategoryDelegate {
    func bindingData()
}

class CategoryViewModel {
    var categoryid: String?

    var categorydelegate: CategoryDelegate?
    var data: CategoryResponse? {
        didSet {
            categorydelegate?.bindingData()
        }
    }
    var data1: CategoryPlaylist? {
        didSet {
            categorydelegate?.bindingData()
        }
    }
    func getData() {
        NetworkManager.shared.getCategories { [weak self] data in
            guard let self = self else { return }
            self.data = data
            
        }
    }
    func getDetail() {
        NetworkManager.shared.getCategoriesPlaylist(id: categoryid ?? "") { [weak self] data1 in
            guard let self = self else { return }
            self.data1 = data1
        }
    }
}
