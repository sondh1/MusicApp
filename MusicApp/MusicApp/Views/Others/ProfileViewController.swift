//
//  ProfileViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/15/23.
//

import UIKit
import Foundation
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = UserProfileViewModel()

    private var models = [String]()
    
    var profile: UserProfile?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getData()

    }

    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
    }
    
    func getData() {
        viewModel.getData()
        viewModel.delegate = self
    }
    
    
    func createCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell",for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createCell(tableView, indexPath)
    }
    
    
}

extension ProfileViewController: ProfileDelegate {
    func bindData() {
        models.append("Full Name: \(viewModel.data?.display_name ?? "")")
        models.append("Email: \(viewModel.data?.display_name ?? "")")
        models.append("ID: \(viewModel.data?.id ?? "")")
        models.append("Products: \(viewModel.data?.product ?? "")")
        let urlString = "\(viewModel.data?.images?[0].url ?? "")"
        let url = URL(string: urlString)
        self.profileImage.sd_setImage(with: url)
        self.tableView.reloadData()
    }
}
