//
//  CategoryCollectionViewCell.swift
//  MusicApp
//
//  Created by QuanDL.FA on 3/30/23.
//

import UIKit
import SDWebImage
class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        image.image = nil
        namelbl.text = nil
    }
    
    func setupCell(image: String, name: String) {
        self.namelbl.text = name
        let urlString = image
        let url = URL(string: urlString)
        self.image.sd_setImage(with: url)
    }

}
