//
//  CreateAccountViewController.swift
//  Cicatribio
//
//  Created by user on 30/09/23.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var CPFTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        let endpointURL = URL(string: "http://localhost:3333/usuarioRegister")!

        guard let nome = nameTextField.text,
              let email = emailTextField.text,
              let cpf = CPFTextField.text,
              let phone = PhoneTextField.text,
              let senha = passwordTextField.text,
              let confirmarSenha = confirmPasswordTextField.text else {
            return
        }

        // Crie os parâmetros que você deseja enviar como um dicionário
        let parameters: [String: Any] = [
            "no_completo": nome,
            "ds_senha": senha,
            "ds_email": email,
            "nu_telefone_completo": phone,
            "nu_cpf": cpf
        ]

        // Crie uma solicitação URLRequest com o URL
        var request = URLRequest(url: endpointURL)

        // Defina o método HTTP como POST
        request.httpMethod = "POST"

        // Defina o cabeçalho Content-Type para application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Converte os parâmetros para dados JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        } catch {
            print("Erro ao criar os dados JSON: \(error.localizedDescription)")
            return
        }

        // Crie uma sessão URLSession
        let session = URLSession.shared

        // Crie uma tarefa de dataTask para fazer a requisição POST
        let task = session.dataTask(with: request) { (data, response, error) in
            // Verifique se ocorreu um erro
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                return
            }

            // Verifique se a resposta do servidor é válida (código de status 200)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // A resposta da API está em 'data'
                if let responseData = data {
                    do {
                        let json = try JSONDecoder().decode(User.self, from: responseData)
                            
                            print("Resposta JSON: \(json)")
                            DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "goToNext", sender: self)
                        }
                    } catch {
                        print("Erro ao fazer o parse dos dados JSON: \(error.localizedDescription)")
                    }
                } else {
                    print("Nenhum dado na resposta")
                }
            } else {
                print("Resposta inválida do servidor")
            }
        }

        // Inicie a tarefa
        task.resume()
    }
    @IBAction func goBackButtonPress(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goBack", sender: self)
    }

}
