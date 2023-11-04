//
//  Anamnese.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 21/10/23.
//

import Foundation

struct Anamnese: Decodable {
    let id: Int
    let mob_usuarios_id: Int?
    let mob_pacientes_id: Int?
    let dt_anamnese: Date?
    let vl_peso: Double?
    let vl_altura: Double?
    let vl_pressao: Double?
    let vl_temperatura: Double?
    let createdAt: String?
    let updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case mob_usuarios_id
        case mob_pacientes_id
        case dt_anamnese
        case vl_peso
        case vl_altura
        case vl_pressao
        case vl_temperatura
        case createdAt
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        mob_usuarios_id = try container.decode(Int.self, forKey: .mob_usuarios_id)
        mob_pacientes_id = try container.decode(Int.self, forKey: .mob_pacientes_id)
        vl_peso = try container.decode(Double?.self, forKey: .vl_peso)
        vl_altura = try container.decode(Double?.self, forKey: .vl_altura)
        vl_pressao = try container.decode(Double?.self, forKey: .vl_pressao)
        vl_temperatura = try container.decode(Double?.self, forKey: .vl_temperatura)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        // Decodificação personalizada para o campo de data
        if let dateString = try container.decodeIfPresent(String.self, forKey: .dt_anamnese) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dt_anamnese = dateFormatter.date(from: dateString)
        } else {
            dt_anamnese = nil
        }
    }
}
