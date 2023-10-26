//
//  LoginViewController.swift
//  Cicatribio
//
//  Created by user on 30/09/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    var id: Int?
    var nomeCompleto: String?
    var email: String?

    let apiManager = ApiManager()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonPress(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
                 let password = passwordTextField.text, !password.isEmpty else {
               showToast(message: "Favor Preencher os campos", isSuccess: false)
               return
           }
        
        apiManager.login(email: email, password: password) { success, user in
            if success, let user = user {
                DispatchQueue.main.async {
                    self.showToast(message: "Login com sucesso", isSuccess: true)
                    UserManager.shared.currentUser = user
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            } else {
                print("Erro no login")
                DispatchQueue.main.async {
                    self.showToast(message: "Erro ao realizar login", isSuccess: false)
                }
                // Trate o erro de login, exiba uma mensagem de erro, etc.
            }
        }
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
//        showToast(message: "Favor Preencher os campos", isSuccess: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {

        }
    }
    
}

extension LoginViewController {
    func showToast(message: String, isSuccess: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            let toastLbl = UILabel()
            toastLbl.text = message
            toastLbl.textAlignment = .center
            toastLbl.font = UIFont.systemFont(ofSize: 18)
            toastLbl.textColor = UIColor.white
            toastLbl.backgroundColor = isSuccess ? UIColor.green.withAlphaComponent(0.6) : UIColor.red.withAlphaComponent(0.6)
            toastLbl.numberOfLines = 0
            
            let textSize = toastLbl.intrinsicContentSize
            let labelHeight = (textSize.width / window.frame.width) * 30
            let labelWidth = min(textSize.width, window.frame.width - 40)
            let adjustedHeight = max(labelHeight, textSize.height + 20)
            
            toastLbl.frame = CGRect(x: 20, y: (window.frame.height - 90) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
            toastLbl.center.x = window.center.x
            toastLbl.layer.cornerRadius = 10
            toastLbl.layer.masksToBounds = true
            
            window.addSubview(toastLbl)
            
            UIView.animate(withDuration: 3.0, animations: {
                toastLbl.alpha = 0
            }) { (_) in
                toastLbl.removeFromSuperview()
            }
        }
    }
}
