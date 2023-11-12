//
//  InjuryType.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 30/10/23.
//

import Foundation

struct InjuryType: Codable {
    let id: Int?
    let mob_anamneses_id: Int?
    let updatedAt: String?
    let createdAt: String?
    let mob_caracteristicas_ferida: InjuryFeatures?
    let mob_imagens_ferida: InjuryImage?
}
