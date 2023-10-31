//
//  DateTableViewCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 26/10/23.
//

import UIKit

protocol DatePickerCellDelegate: AnyObject {
    func dateDidChange(newDate: Date)
}

class DateTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    static let identifier = "DateTableViewCell"
    
    public func configure(with title: String, delegate: DatePickerCellDelegate) {
        titleLabel.text = title
        self.delegate = delegate
    }
    
    weak var delegate: DatePickerCellDelegate?
    
    
    static func nib() -> UINib {
        return UINib(nibName: "DateTableViewCell", bundle: nil)
    }
    
    public func configure(with title: String) {
        titleLabel.text = title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        // Initialization code
    }

    @objc func dateChanged() {
        delegate?.dateDidChange(newDate: datePicker.date)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
