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

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let endpointURL = URL(string: "http://localhost:3333/usuarioLogin")!

    @IBAction func loginButtonPress(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        	
        let parameters: [String: String] = [
            "nu_cpf": email,
            "ds_senha": password
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
                               
                               if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                                   if let id = json["id"] as? Int,
                                      let nomeCompleto = json["no_completo"] as? String,
                                      let email = json["ds_email"] as? String {
                                       // Agora você tem os dados do usuário disponíveis
                                       print("ID: \(id)")
                                       print("Nome Completo: \(nomeCompleto)")
                                       print("E-mail: \(email)")
                                       
                                       self.id = id
                                       self.nomeCompleto = nomeCompleto
                                       self.email = email
                                       DispatchQueue.main.async {
                                           self.performSegue(withIdentifier: "goToNext", sender: self)
                                       }
                                   } else {
                                       print("Não foi possível extrair informações do JSON")
                                   }
                               } else {
                                   print("Não foi possível fazer o parse do JSON")
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
    
    
    @IBAction func registerButtonPress(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {

        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
