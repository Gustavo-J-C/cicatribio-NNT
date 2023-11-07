//
//  MobilitType.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import Foundation

class MobilityType: DataOptionType, Decodable {
    let ds_tipo_mobilidade: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ds_tipo_mobilidade
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ds_tipo_mobilidade = try container.decode(String.self, forKey: .ds_tipo_mobilidade)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        super.init(value: ds_tipo_mobilidade, type: .mobility)
        id = try  container.decode(Int.self, forKey: .id)
    }
}
