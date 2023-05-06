//
//  PlaylistTableViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/21/23.
//

import UIKit
import SDWebImage

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.author.text = ""
        self.name.text = ""
        self.image1.image = nil
    }
    
    func setupCell(img: String, author: String, name: String) {
        self.name.text = name
        self.author.text = author
        let urlString = img
        let url = URL(string: urlString)
        self.image1.sd_setImage(with: url, placeholderImage: UIImage(systemName: "photo"))
    }
    
}
