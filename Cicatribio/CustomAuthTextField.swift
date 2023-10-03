//
//  CustomAuthTextField.swift
//  Cicatribio
//
//  Created by user on 23/09/23.
//

import UIKit

class CustomAuthTextField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1).cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
        
    }

}
