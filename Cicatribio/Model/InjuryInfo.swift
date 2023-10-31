//
//  InjuryInfo.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 30/10/23.
//

import Foundation

struct InjuryInfo: Decodable {
    let id : Int
    let mob_tipo_sintomas_id: Int
    let mob_tipo_tecidos_id: Int
    let mob_local_feridas_id: Int
    let mob_tipo_exsudatos_id: Int
    let mob_qtd_exsudatos_id: Int
    let mob_feridas_id: Int
    let vl_comprimento: Double?
    let vl_largura: Double?
}
