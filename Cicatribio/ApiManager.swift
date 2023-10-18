//
//  ApiManager.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 19/10/23.
//

import Foundation

struct ApiManager {
    
    let apiUrl = "https://cicatribio-server-nnt.onrender.com/"
    
    func fetchUsers(endpoint: String) {
        let urlString = "\(apiUrl)\(endpoint)"
        peformRequest(urlString: urlString)
    }
    
    
    func peformRequest(urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    let data = parseJson(apiData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJson(apiData: Data) -> [PatientsData]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([PatientsData].self, from: apiData)
            print(decodedData[0])
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
