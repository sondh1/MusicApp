//
//  Section3CollectionViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/17/23.
//

import UIKit

class Section3CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(image: String, name: String, author: String) {
        let urlString = image
        let url = URL(string: urlString)
        self.image.sd_setImage(with: url)
        self.name.text = name
        self.author.text = author

    }

}
