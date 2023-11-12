//
//  InjuryFeatures.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 09/11/23.
//

import Foundation

struct InjuryFeatures: Codable{
    let id: Int
    let mobTipoSintomasId: Int?
    let mobTipoTecidosId: Int?
    let mobLocalFeridasId: Int?
    let mobTipoExsudatosId: Int?
    let mobQtdExsudatosId: Int?
    let mobFeridasId: Int?
    let vlComprimento: Double?
    let vlLargura: Double?
    let createdAt: String?
    let updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case mobTipoSintomasId = "mob_tipo_sintomas_id"
        case mobTipoTecidosId = "mob_tipo_tecidos_id"
        case mobLocalFeridasId = "mob_local_feridas_id"
        case mobTipoExsudatosId = "mob_tipo_exsudatos_id"
        case mobQtdExsudatosId = "mob_qtd_exsudatos_id"
        case mobFeridasId = "mob_feridas_id"
        case vlComprimento = "vl_comprimento"
        case vlLargura = "vl_largura"
        case createdAt
        case updatedAt
    }
}
