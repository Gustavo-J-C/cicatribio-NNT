//
//  File.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import Foundation

class SymptomType: DataOptionType, Decodable {
    let ds_tipo_sintomas: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ds_tipo_sintomas
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ds_tipo_sintomas = try container.decode(String.self, forKey: .ds_tipo_sintomas)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode (String.self, forKey: .updatedAt)
        
        super.init(value: ds_tipo_sintomas, type: .hygiene)
        id = try  container.decode(Int.self, forKey: .id)
    }
}
