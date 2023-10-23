//
//  MobilitType.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import Foundation

struct MobilitType: Decodable {
    let id: Int
    let ds_tipo_mobilidade: String
    let createdAt: Date
    let updatedAt: Date
}
