//
//  InjuryImage.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 10/11/23.
//

import Foundation

struct InjuryImage: Codable {
    let id: Int?
    let mob_caracteristicas_feridas_id: Int?
    let mob_feridas_id: Int?
    let ds_caminho_server: String?
    let vl_largura_imagem: Double?
    let vl_altura_imagem: Double?
    let vl_largura_detector: Double?
    let vl_altura_detector: Double?
    let vl_eixo_x: Double?
    let vl_eixo_y: Double?
    let createdAt: String?
    let updatedAt: String?
}
