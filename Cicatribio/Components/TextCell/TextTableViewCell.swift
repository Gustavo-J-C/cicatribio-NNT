//
//  TextTableViewCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 27/10/23.
//

import UIKit

protocol TextTableViewCellDelegate: AnyObject {
    func textFieldDidChange(_ text: String, for key: String)
}

class TextTableViewCell: UITableViewCell {

    static let identifier = "TextTableViewCell"
    
    weak  var delegate: TextTableViewCellDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    static func nib() -> UINib {
        return UINib(nibName: "TextTableViewCell", bundle: nil)
    }
    
    public func configure(with title: String, delegate: TextTableViewCellDelegate) {
        titleLabel.text = title
        textField.delegate = self
        self.delegate = delegate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TextTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidChange(textField.text ?? "", for: titleLabel.text ?? "")
    }
}
