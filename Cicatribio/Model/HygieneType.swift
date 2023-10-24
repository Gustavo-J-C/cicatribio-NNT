//
//  MobilityType.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import Foundation

class HygieneType: DataOptionType, Decodable {
    let id: Int
    let ds_tipo_higiene: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ds_tipo_higiene
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try  container.decode(Int.self, forKey: .id)
        ds_tipo_higiene = try container.decode(String.self, forKey: .ds_tipo_higiene)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode (String.self, forKey: .updatedAt)
        
        super.init(value: ds_tipo_higiene, type: .hygiene)
    }
}
