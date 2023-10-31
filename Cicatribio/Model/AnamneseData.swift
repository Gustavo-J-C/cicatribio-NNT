//
//  AnamneseData.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 27/10/23.
//

import Foundation

struct AnamneseData: Decodable {
    let id: Int
    let mob_usuarios_id: Int
    let mob_pacientes_id: Int
    let dt_anamnese: String
    let vl_peso: Double
    let vl_altura: Double
    let vl_pressao: Int?
    let vl_temperatura: Double?
}
