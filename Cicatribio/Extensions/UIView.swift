//
//  UIView.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 27/10/23.
//

import UIKit

extension UIView {
    func showToast(message: String, isSuccess: Bool) {
        let toastLbl = UILabel()
        toastLbl.text = message
        toastLbl.textAlignment = .center
        toastLbl.font = UIFont.systemFont(ofSize: 18)
        toastLbl.textColor = UIColor.white
        toastLbl.backgroundColor = isSuccess ? UIColor.green.withAlphaComponent(0.6) : UIColor.red.withAlphaComponent(0.6)
        toastLbl.numberOfLines = 0
        
        let textSize = toastLbl.intrinsicContentSize
        let labelHeight = (textSize.width / self.frame.width) * 30
        let labelWidth = min(textSize.width, self.frame.width - 40)
        let adjustedHeight = max(labelHeight, textSize.height + 20)
        
        if #available(iOS 11.0, *) {
            let safeAreaTop = self.safeAreaInsets.top
            toastLbl.frame = CGRect(x: 20, y: safeAreaTop + 10, width: labelWidth + 20, height: labelHeight + 20)
        } else {
            toastLbl.frame = CGRect(x: 20, y: 80, width: labelWidth + 20, height: labelHeight + 20)
        }
        toastLbl.center.x = self.center.x
        toastLbl.layer.cornerRadius = 10
        toastLbl.layer.masksToBounds = true
        
        self.addSubview(toastLbl)
        
        UIView.animate(withDuration: 3.0, animations: {
            toastLbl.alpha = 0
        }) { (_) in
            toastLbl.removeFromSuperview()
        }
    }
}
