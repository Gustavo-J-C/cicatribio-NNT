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
    
    func fetchAndDecode<T: Decodable>(_ endpoint: String, type: T.Type, completion: @escaping (T?) -> Void) {
        let urlString = "\(apiUrl)\(endpoint)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    completion(nil)
                    return
                }
                
                if let safeData = data {
                    let decodedData = parseJson(apiData: safeData, dataType: T.self)
                    completion(decodedData)
                }
            }
            task.resume()
        }
    }
    
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
                        self.fetchHygieneTypes()
                        self.fetchMobilityTypes()
                        self.fetchSelfCareTypes()
                        self.fetchSkinTypes()
                        self.fetchInjurySites()
                        self.fetchExudateAmounts()
                        self.fetchExudateTypes()
                        self.fetchSymptomsTypes()
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


    func postAnamnese(endpoint: String, postData: [String: Any], completion: @escaping (AnamneseData?, Error?) -> Void) {
        let urlString = "\(apiUrl)\(endpoint)"
        guard let apiURL = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    do {
                        let anamneseData = try JSONDecoder().decode(AnamneseData.self, from: data)
                        completion(anamneseData, nil)
                    } catch (let e) {
                        
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        } catch {
            completion(nil, error)
        }
    }
    
    func postData<T: Decodable>(endpoint: String, postData: [String: Any], dataType: T.Type, completion: @escaping (T?, Error?) -> Void) {
        let urlString = "\(apiUrl)\(endpoint)"
        guard let apiURL = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted)
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    do {
                        let anamneseData = try JSONDecoder().decode(T.self, from: data)
                        completion(anamneseData, nil)
                    } catch let decodingError {
                        completion(nil, decodingError)
                    }
                }
            }
            task.resume()
        } catch let serializationError {
            completion(nil, serializationError)
        }
    }

    func checkerPost(b64: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = URL(string: "https://identify-sticker-app-ycujh.ondigitalocean.app/verifyImage")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Crie um limite de dados multipart
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Adicione o campo "b64" como parte do corpo multipart
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"b64\"\r\n\r\n".data(using: .utf8)!)
        body.append(b64.data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        
        // Adicione a parte final do limite multipart
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let emptyDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(emptyDataError))
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonObject))
                } else {
                    let jsonParsingError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])
                    completion(.failure(jsonParsingError))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    
    func postToSegImg(key_img: String, img_id: Int, b64img: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let url = URL(string: "https://segmentation-app-b9v68.ondigitalocean.app/segImg")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Crie um dicionário com os dados a serem enviados como JSON
        let postDictionary: [String: Any] = [
            "key_img": key_img,
            "img_id": img_id,
            "imgs": [b64img]
        ]
        
        do {
            // Serialize o dicionário como JSON
            let jsonData = try JSONSerialization.data(withJSONObject: postDictionary, options: [])
            
            // Defina o corpo da solicitação como dados JSON
            request.httpBody = jsonData
            
            // Defina o cabeçalho "Content-Type" para indicar que você está enviando JSON
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let emptyDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    completion(.failure(emptyDataError))
                    return
                }
                
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        completion(.success(jsonObject))
                    } else {
                        let jsonParsingError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse JSON"])
                        completion(.failure(jsonParsingError))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchMobilityTypes() {
        let endpoint = "tipoMobilidade"
        fetchAndDecode(endpoint, type: [MobilityType].self) { mobilityTypes in
            if let mobilityTypes = mobilityTypes {
                UserManager.shared.mobilityTypes = mobilityTypes
            }
        }
    }

    // Função para buscar e popular os tipos de higiene
    func fetchHygieneTypes() {
        let endpoint = "tipoHigiene"
        fetchAndDecode(endpoint, type: [HygieneType].self) { hygieneTypes in
            if let hygieneTypes = hygieneTypes {
                UserManager.shared.hygieneTypes = hygieneTypes
            }
        }
    }
    
    func fetchSelfCareTypes() {
        let endpoint = "autoCuidado"
        fetchAndDecode(endpoint, type: [SelfCareType].self) { selfCareTypes in
            if let selfCareTypes = selfCareTypes {
                UserManager.shared.selfCareTypes = selfCareTypes
            }
        }
    }
    
    func fetchSymptomsTypes() {
        let endpoint = "tipoSintoma"
        fetchAndDecode(endpoint, type: [SymptomType].self) { symptomsTypes in
            if let symptomsTypes = symptomsTypes {
                UserManager.shared.symptomsTypes = symptomsTypes
            }
        }
    }
    func fetchExudateTypes() {
        let endpoint = "tipoExsudato"
        fetchAndDecode(endpoint, type: [ExudateType].self) { exudateTypes in
            if let exudateTypes = exudateTypes {
                UserManager.shared.exudateTypes = exudateTypes
            }
        }
    }
    func fetchInjurySites() {
        let endpoint = "localFerida"
        fetchAndDecode(endpoint, type: [InjurySite].self) { injurySites in
            if let injurySites = injurySites {
                UserManager.shared.injurySites = injurySites
            }
        }
    }
    func fetchExudateAmounts() {
        let endpoint = "qtdExsudato"
        fetchAndDecode(endpoint, type: [ExudateAmount].self) { exudateAmounts in
            if let exudateAmounts = exudateAmounts {
                UserManager.shared.exudateAmounts = exudateAmounts
            }
        }
    }
    func fetchSkinTypes() {
        let endpoint = "tipoTecido"
        fetchAndDecode(endpoint, type: [SkinType].self) { skinTypes in
            if let skinTypes = skinTypes {
                UserManager.shared.skinTypes = skinTypes
            }
        }
    }
}
