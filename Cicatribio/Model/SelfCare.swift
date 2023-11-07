//
//  SelfCare.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import Foundation

class SelfCareType: DataOptionType, Decodable {
    let ds_auto_cuidado: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ds_auto_cuidado
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ds_auto_cuidado = try container.decode(String.self, forKey: .ds_auto_cuidado)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        super.init(value: ds_auto_cuidado, type: OptionsType.selfCare)
        id = try  container.decode(Int.self, forKey: .id)
    }
}
