//
//  userData.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import Foundation

struct User: Decodable {
    let id: Int
    let no_completo: String
    let ds_email: String
    let nu_telefone_completo: String
    let nu_cpf: Int
    let createdAt: String
    let updatedAt: String
}
