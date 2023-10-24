//
//  DataOptionType.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 24/10/23.
//

import Foundation

enum OptionsType {
    case skin
    case mobility
    case selfCare
    case hygiene
}

class DataOptionType {
    let value: String
    var type: OptionsType

    init(value: String, type: OptionsType) {
        self.value = value
        self.type = type
    }
}
