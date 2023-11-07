//
//  ExudateAmount.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import Foundation

class ExudateAmount: DataOptionType, Decodable {
    let ds_qtd_exsudatos: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ds_qtd_exsudatos
        case createdAt
        case updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ds_qtd_exsudatos = try container.decode(String.self, forKey: .ds_qtd_exsudatos)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode (String.self, forKey: .updatedAt)
        
        super.init(value: ds_qtd_exsudatos, type: .hygiene)
        id = try  container.decode(Int.self, forKey: .id)
    }
}
