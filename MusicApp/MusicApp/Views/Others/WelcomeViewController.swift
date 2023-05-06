//
//  WelcomeViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/13/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func signIn(_ sender: Any) {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.handleSignIn(success: success)
                
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
    
}
