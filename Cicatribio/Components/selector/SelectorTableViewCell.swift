//
//  SelectorTableViewCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import UIKit

protocol SelectorTableViewCellDelegate: AnyObject {
    func pickerViewDidSelectValue(_ value: String)
}

class SelectorTableViewCell: UITableViewCell {
    
    
    let pickerView = UIPickerView()
    static let identifier = "SelectorTableViewCell"
    weak var delegate: SelectorTableViewCellDelegate?
    
    static func nib() -> UINib {
        return UINib(nibName: "SelectorTableViewCell", bundle: nil)
    }
    
    public func configure(with type: String) {
        
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        searchTextField.inputView = pickerView
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension SelectorTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UserManager.shared.hygieneTypes!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return UserManager.shared.hygieneTypes?[row].ds_tipo_higiene
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedValue = UserManager.shared.hygieneTypes?[row].ds_tipo_higiene

        searchTextField.text = selectedValue
        searchTextField.resignFirstResponder()
        delegate?.pickerViewDidSelectValue(selectedValue!)
    }
}
