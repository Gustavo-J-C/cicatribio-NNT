//
//  AnamnesesCollectionViewCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import UIKit

class AnamnesesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    static let identifier: String = "AnamnesesCollectionViewCell"
    var currentIndex: Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "AnamnesesCollectionViewCell", bundle: nil)
    }

    @IBAction func handleRemove(_ sender: UIButton) {
    }
}
