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
        PhoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        CPFTextField.addTarget(self, action: #selector(cpfTextFieldDidChange), for: .editingChanged)
    }
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        guard let cpf = CPFTextField.text, cpf.isCPF else {
            print("CPF inválido")
            self.view.showToast(message: "Favor insira um CPF válido", isSuccess: false)
            return
        }

        // Validação do campo de telefone
        guard let phone = PhoneTextField.text, isValidPhoneNumber(phone) else {
            self.view.showToast(message: "Favor insira um telefone válido", isSuccess: false)
            return
        }
        
        let endpointURL = URL(string: "http://localhost:3333/usuarioRegister")!

        guard let nome = nameTextField.text, !nome.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let senha = passwordTextField.text, !senha.isEmpty,
              let confirmarSenha = confirmPasswordTextField.text, !confirmarSenha.isEmpty else {
            self.view.showToast(message: "Favor preencher todos os campos", isSuccess: false)
            return
        }

        if senha != confirmarSenha {
            self.view.showToast(message: "As senhas não coincidem", isSuccess: false)
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
    
    @objc func cpfTextFieldDidChange() {
        if let text = CPFTextField.text {
            // Remover caracteres não numéricos (como espaços e traços)
            let numericText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if numericText.count == 11 {
                if numericText.isCPF {
                    CPFTextField.text = formattedCPF(numericText)
                } else {
                    print("CPF inválido")
                }
            }
        }
    }
    
    func isValidPhoneNumber(_ phone: String) -> Bool {
        let numericText = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Verificar se o número de telefone tem 11 dígitos
        if numericText.count != 11 {
            return false
        }
        
        // Verificar se todos os caracteres são numéricos
        if let _ = Int(numericText) {
            // Formatar como (XX) XXXXX-XXXX
            let formattedPhoneNumber = "(\(numericText.prefix(2))) \(numericText.dropFirst(2).prefix(5))-\(numericText.dropFirst(7))"
            PhoneTextField.text = formattedPhoneNumber
            return true
        } else {
            return false
        }
    }
    
    func formattedCPF(_ cpf: String) -> String {
        let formattedCPF = "\(cpf.prefix(3)).\(cpf.dropFirst(3).prefix(3)).\(cpf.dropFirst(6).prefix(3))-\(cpf.suffix(2))"
        return formattedCPF
    }

    @objc func textFieldDidChange() {
        if let text = PhoneTextField.text {
            let numericText = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            if numericText.count > 11 {
                PhoneTextField.text = String(numericText.prefix(11))
            }
            
            if numericText.count == 11 {
                let formattedPhoneNumber = "(\(numericText.prefix(2))) \(numericText.dropFirst(2).prefix(5))-\(numericText.dropFirst(7))"
                PhoneTextField.text = formattedPhoneNumber
            }
        }
    }
}
