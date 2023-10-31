//
//  UIViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 30/10/23.
//

import Foundation
import UIKit

extension UIViewController {
    func dismissAllViewControllers() {
        if let presentingViewController = self.presentingViewController {
            presentingViewController.dismiss(animated: true, completion: {
                presentingViewController.dismissAllViewControllers()
            })
        } else {
            // Não há mais view controllers para "dismiss"
        }
    }
    
    func dismissToAnamnesesViewController() {
        if let presentingViewController = self.presentingViewController {
            if let anamnesesViewController = presentingViewController as? LoginViewController {
                // Chegou à AnamnesesViewController, pare a recursão
                return
            }
            presentingViewController.dismiss(animated: true, completion: {
                presentingViewController.dismissToAnamnesesViewController() // Chamada recursiva
            })
        } else {
            // Não há mais view controllers para "dismiss" ou chegou ao topo da pilha
        }
    }
}
