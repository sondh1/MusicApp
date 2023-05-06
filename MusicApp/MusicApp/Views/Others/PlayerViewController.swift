//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/15/23.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func pause()
    func next()
    func back()
    func slide(_ value: Float)
}

class PlayerViewController: UIViewController {

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    private var isPlaying = true
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        configureBarButton()
        configure()
    }
    
    private func configureBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    private func configure() {
        if dataSource?.imageURL == nil {
            image.image = UIImage(named: "musium logo")
        } else {
            image.sd_setImage(with: dataSource?.imageURL, completed: nil)
        }
        mainTitle.text = dataSource?.songName
        subtitle.text = dataSource?.descriptionTitle
        
        
    }

    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }


    @objc func didTapShare() {
        
    }
    

    @IBAction func didSlide(_ slider: UISlider) {
        let value = slider.value
        delegate?.slide(value)
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        delegate?.back()
    }
    
    @IBAction func didTapPause(_ sender: Any) {
        self.isPlaying = !isPlaying
        delegate?.pause()
        
        let pause = UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        let play = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        pauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    
    @IBAction func didTapNext(_ sender: Any) {
        delegate?.next()
    }
    
    func refreshUI() {
        configure()
    }
}
