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
    
    let endpointURL = URL(string: "http://localhost:3333/usuarioLogin")!

    @IBAction func loginButtonPress(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        apiManager.login(email: email, password: password) { success, user in
            if success, let user = user {
                
                DispatchQueue.main.async {
                    UserManager.shared.currentUser = user
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            } else {
                print("Erro no login")
                // Trate o erro de login, exiba uma mensagem de erro, etc.
            }
        }
    }
    
    
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {

        }
    }

}
