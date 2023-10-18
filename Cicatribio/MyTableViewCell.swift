//
//  MyTableViewCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 19/10/23.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell",
                      bundle: nil)
    }
    
    public func configure(with title: String, imageName: String) {
        myLabel.text = title
        myImageView.image = UIImage(systemName: imageName)
    }
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.contentMode = .scaleAspectFit
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
