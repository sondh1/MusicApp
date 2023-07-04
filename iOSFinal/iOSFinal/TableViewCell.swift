//
//  TableViewCell.swift
//  iOSFinal
//
//  Created by QuanDL.FA on 1/31/23.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {

    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        reset()
    }
    func reset() {
        label1.text = ""
        label2.text = ""
        label3.text = ""
        img1.image = UIImage(named: "")
    }
    func setupCell(label1: String, label2: String, label3: String, img1: String) {
        self.label1.text = label1
        self.label2.text = label2
        self.label3.text = label3
        let url = "https:\(img1)"
        let url1 = URL(string: url)
        self.img1.sd_setImage(with: url1)
    }
    
}
