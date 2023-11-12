//
//  EditProfileViewController.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 04/11/23.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    let apiManager = ApiManager()
    
    static let identifier: String = "EditProfileViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        phoneTextField.text = UserManager.shared.currentUser?.nu_telefone_completo
        nameTextField.text = UserManager.shared.currentUser?.no_completo
    }

    @objc func textFieldDidChange() {
        if let text = phoneTextField.text {
            let numericText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if numericText.count > 11 {
                phoneTextField.text = String(numericText.prefix(11))
            }
            
            if numericText.count == 11 {
                let formattedPhoneNumber = "(\(numericText.prefix(2))) \(numericText.dropFirst(2).prefix(5))-\(numericText.dropFirst(7))"
                phoneTextField.text = formattedPhoneNumber
            }
        }
    }
    
    
    
    @IBAction func handleSave(_ sender: UIButton) {
        if let id = UserManager.shared.currentUser?.id {
            apiManager.postUserForEdit(name: nameTextField.text!, phone: phoneTextField.text!, id: String(id)) { success, user in
                if success {
                    // Usuário enviado com sucesso, faça o que for necessário com o usuário retornado
                    print("Usuário enviado com sucesso: \(user)")
                    UserManager.shared.currentUser?.no_completo = user!["name"] as! String
                    UserManager.shared.currentUser?.nu_telefone_completo = user!["phone"] as! String
                    DispatchQueue.main.async {
                        self.view.showToast(message: "Usuário atualizado com sucesso", isSuccess: true)
                    }
                } else {
                    // Houve um erro ao enviar o usuário
                    print("Erro ao enviar o usuário")
                }
            }
        }
    }
}
