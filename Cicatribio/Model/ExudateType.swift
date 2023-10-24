//
//  ExudateType.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import Foundation

class ExudateType: DataOptionType, Decodable {
    let id: Int
    let ds_tipo_exsudatos: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ds_tipo_exsudatos
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try  container.decode(Int.self, forKey: .id)
        ds_tipo_exsudatos = try container.decode(String.self, forKey: .ds_tipo_exsudatos)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode (String.self, forKey: .updatedAt)
        
        super.init(value: ds_tipo_exsudatos, type: .hygiene)
    }
}
