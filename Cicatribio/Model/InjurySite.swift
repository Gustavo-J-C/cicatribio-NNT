//
//  InjurySite.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import Foundation

class InjurySite: DataOptionType, Decodable {
    let id: Int
    let ds_local_feridas: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ds_local_feridas
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try  container.decode(Int.self, forKey: .id)
        ds_local_feridas = try container.decode(String.self, forKey: .ds_local_feridas)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode (String.self, forKey: .updatedAt)
        
        super.init(value: ds_local_feridas, type: .hygiene)
    }
}
