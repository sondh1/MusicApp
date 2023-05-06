//
//  Section1CollectionViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/17/23.
//

import UIKit
import SDWebImage

class Section1CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var totalTracks: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(img: String, name: String, author: String, totalTracks: String) {
        self.name.text = name
        self.author.text = author
        self.totalTracks.text = "Tracks: \(totalTracks)"
        let urlString = img
        let url = URL(string: urlString)
        self.image.sd_setImage(with: url)
    }

}
