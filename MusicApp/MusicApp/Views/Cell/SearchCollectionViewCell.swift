//
//  SearchCollectionViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/28/23.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {

    

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        name.text = ""
        image.image = nil
    }
    func setupCell(name: String, image: String){
        self.name.text = name
        let urlString = image
        let url = URL(string: urlString)
        self.image.sd_setImage(with: url)
    }
}
