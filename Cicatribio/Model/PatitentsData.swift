//
//  PatitentsData.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 19/10/23.
//

import Foundation

struct PatientsData: Decodable {
    let id: Int
    let no_completo: String
    let ds_email: String
    let dt_nascimento: String
}
