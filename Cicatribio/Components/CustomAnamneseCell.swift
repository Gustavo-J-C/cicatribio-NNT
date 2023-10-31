//
//  CustomAnamneseCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 21/10/23.
//

import UIKit

class CustomAnamneseCell: UITableViewCell {

    static let identifier = "CustomAnamneseCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "CustomAnamneseCell", bundle: nil)
    }
    
    public func configure(with date: Date?) {
        dateLabel.text = date!.formatted()
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var delegate: ApiManagerDelegate?
}

