//
//  ApiManager.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 19/10/23.
//

import Foundation

protocol ApiManagerDelegate {
    func didUpdateData<T>(_ data: T?)
}

struct ApiManager {
    
    let apiUrl = "http://localhost:3333/"
    
    func fetchData<T: Decodable>(endpoint: String, type: T.Type) {
        let urlString = "\(apiUrl)\(endpoint)"
        performRequest(urlString: urlString, dataType: type)
    }
    
//    func fetchUsers(endpoint: String) {
//        let urlString = "\(apiUrl)\(endpoint)"
//        performRequest(urlString: urlString)
//    }
    
    var delegate: ApiManagerDelegate?
    
    func performRequest<T: Decodable>(urlString: String, dataType: T.Type) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let data = parseJson(apiData: safeData, dataType: dataType) {
                        delegate?.didUpdateData(data)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson<T: Decodable>(apiData: Data, dataType: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: apiData)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, User?) -> Void) {
        let endpoint = "usuarioLogin"
        let urlString = "\(apiUrl)\(endpoint)"

        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "nu_cpf": email,
            "ds_senha": password
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        } catch {
            print("Erro ao criar os dados JSON: \(error.localizedDescription)")
            completion(false, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro na requisição: \(error.localizedDescription)")
                completion(false, nil)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let responseData = data {
                    do {
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: responseData)
                        completion(true, user)
                    } catch {
                        print("Erro ao fazer o parse dos dados JSON: \(error.localizedDescription)")
                        completion(false, nil)
                    }
                } else {
                    print("Nenhum dado na resposta")
                    completion(false, nil)
                }
            } else {
                print("Resposta inválida do servidor")
                completion(false, nil)
            }
        }

        task.resume()
    }

}
