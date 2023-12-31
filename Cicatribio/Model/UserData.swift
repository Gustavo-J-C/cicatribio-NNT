//
//  userData.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import Foundation

struct User: Decodable, Encodable {
    let id: Int
    var no_completo: String?
    let ds_email: String
    var nu_telefone_completo: String?
    let nu_cpf: Int
    let createdAt: String
    let updatedAt: String
}
