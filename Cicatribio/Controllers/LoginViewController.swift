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
        if let userDefaults = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userDefaults) {
            // Um usuário foi encontrado, vá para a tela de home e configure o UserManager
            UserManager.shared.currentUser = user
            if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "MainTabBar") {
                present(tabBarController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func loginButtonPress(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            self.view.showToast(message: "Favor preencher os campos", isSuccess: false)
            return
        }

        if !email.isCPF {
            // O texto não é um CPF válido
            self.view.showToast(message: "Favor insira um CPF válido", isSuccess: false)
            return
        }
        
        apiManager.login(email: email, password: password) { success, user in
            if success, let user = user {
                DispatchQueue.main.async {
                    self.view.showToast(message: "Login com sucesso", isSuccess: true)
                    
                    let userDefaults = UserDefaults.standard
                    let userEncoder = JSONEncoder()
                    
                    if let encodedUser = try? userEncoder.encode(user) {
                        userDefaults.set(encodedUser, forKey: "currentUser")
                    }
                    
                    UserManager.shared.currentUser = user
                    self.passwordTextField.text = ""
                    self.emailTextField.text = ""
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            } else {
                print("Erro no login")
                DispatchQueue.main.async {
                    self.view.showToast(message: "Erro ao realizar login", isSuccess: false)
                }
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
