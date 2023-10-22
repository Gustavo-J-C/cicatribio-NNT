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
}
