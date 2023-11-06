//
//  PhoneTableViewCell.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 04/11/23.
//

import UIKit

protocol PhoneCellDelegate: AnyObject {
    func phoneCell(_ cell: PhoneTableViewCell, didChangePhoneNumber phoneNumber: String)
}

class PhoneTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "PhoneCellDelegate"
    @IBOutlet weak var phoneTextField: UITextField!
    
    weak var delegate: PhoneCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PhoneTableViewCell", bundle: nil)
    }

    @objc func textFieldDidChange() {
        if let text = phoneTextField.text {
            // Remover caracteres não numéricos (como espaços e traços)
            let numericText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if numericText.count > 11 {
                // Se o número já tem 11 dígitos, limite o texto
                phoneTextField.text = String(numericText.prefix(11))
            }
            
            if numericText.count == 11 {
                // Formatar como (XX) XXXXX-XXXX
                let formattedPhoneNumber = "(\(numericText.prefix(2))) \(numericText.dropFirst(2).prefix(5))-\(numericText.dropFirst(7))"
                phoneTextField.text = formattedPhoneNumber
            }
            
            delegate?.phoneCell(self, didChangePhoneNumber: numericText)
        }
    }
}
