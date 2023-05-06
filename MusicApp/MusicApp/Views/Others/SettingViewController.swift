//
//  SettingViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/15/23.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        sections.append(Section(title: "Profile", option: [Option(title: "View your profile" , handler: { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.viewProfile()
            }
        })]))
        sections.append(Section(title: "Account", option: [Option(title: "Sign out" , handler: { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.SignOut()
            }
        })]))
    }
    
    private func viewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    private func SignOut() {
        let alert = UIAlertController(title: "Sign out", message: "Do you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] signOut in
                if signOut {
                    DispatchQueue.main.async {
                        let vc = UINavigationController(rootViewController: WelcomeViewController())
                        vc.navigationBar.prefersLargeTitles = true
                        vc.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: {
                            self?.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
    }
    func createCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].option[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell",for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = model.title
        return cell
    }
    
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].option.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        createCell(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticsManager.shared.vibrateForSelection()
        tableView.deselectRow(at: indexPath, animated: true)
        let model = sections[indexPath.section].option[indexPath.row]
        model.handler()
    }
    
}
