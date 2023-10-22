//
//  PatitentsData.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 19/10/23.
//

import Foundation

struct PatientsData: Decodable {
    let id: Int
    let no_completo: String
    let nu_cpf: String
    let ds_sexo: Int
    let ds_cor_raca: String
    let dt_nascimento: Date
    let ds_email: String
    let ds_ocupacao: String
    let nu_telefone_completo: String
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case no_completo = "no_completo"
        case nu_cpf = "nu_cpf"
        case ds_sexo = "ds_sexo"
        case ds_cor_raca = "ds_cor_raca"
        case dt_nascimento = "dt_nascimento"
        case ds_email = "ds_email"
        case ds_ocupacao = "ds_ocupacao"
        case nu_telefone_completo = "nu_telefone_completo"
        case createdAt
        case updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        no_completo = try container.decode(String.self, forKey: .no_completo)
        nu_cpf = try container.decode(String.self, forKey: .nu_cpf)
        ds_sexo = try container.decode(Int.self, forKey: .ds_sexo)
        ds_cor_raca = try container.decode(String.self, forKey: .ds_cor_raca)
        
        let dateFormatter = DateFormatter()
        let birtdayDateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        birtdayDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = try container.decode(String.self, forKey: .dt_nascimento)
        if let date = birtdayDateFormatter.date(from: dateString) {
            dt_nascimento = date
        } else {
            print("Erro ao converter a data: \(dateString)")
            throw DecodingError.dataCorruptedError(forKey: .dt_nascimento, in: container, debugDescription: "Date string could not be converted.")
        }
        
        ds_email = try container.decode(String.self, forKey: .ds_email)
        ds_ocupacao = try container.decode(String.self, forKey: .ds_ocupacao)
        nu_telefone_completo = try container.decode(String.self, forKey: .nu_telefone_completo)
        
        let createdDateString = try container.decode(String.self, forKey: .createdAt)
        if let date = dateFormatter.date(from: createdDateString) {
            createdAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "Date string could not be converted.")
        }
        
        let updatedDateString = try container.decode(String.self, forKey: .updatedAt)
        if let date = dateFormatter.date(from: updatedDateString) {
            updatedAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .updatedAt, in: container, debugDescription: "Date string could not be converted.")
        }
    }
}
