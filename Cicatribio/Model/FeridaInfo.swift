//
//  FeridaInfo.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 30/10/23.
//

import Foundation

struct FeridaInfo: Decodable {
    let id: Int?
    var mob_feridas_id: Int?
    var mob_caracteristicas_feridas_id: Int?
    var vl_largura_imagem: Double?
    var vl_altura_imagem: Double?
    var vl_largura_detector: Double?
    var vl_altura_detector: Double?
    var vl_eixo_x: Double?
    var vl_eixo_y: Double?
}
