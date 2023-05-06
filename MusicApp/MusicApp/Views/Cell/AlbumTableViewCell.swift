//
//  AlbumTableViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/22/23.
//

import UIKit


class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var name: UILabel!
    
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
    }
    
    func setupCell(author: String, name: String) {
        self.name.text = name
        self.author.text = author
    }
    
}
