//
//  SearchResultTableViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/30/23.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        lbl.text = ""
        author.text = ""
        img.image = nil
    }
    
    func setupCell(name: String, author: String, image: String) {
        lbl.text = name
        self.author.text = author
        let url = URL(string: image)
        img.sd_setImage(with: url)
        
    }
    
}
