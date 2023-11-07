//
//  AnamneseInfo.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 27/10/23.
//

import Foundation

struct AnamneseInfo {
    var patientId: Int?
    var selectedDate: Date?
    var weightKg: Double?
    var heightM: Double?
    
    var mobilitType: Int?
    var selfCare: Int?
    var hygieneType: Int?
    var symptomType: Int?
    
    var skinType: Int?
    var injurySite: Int?
    var exudateType: Int?
    var exudateAmount: Int?
    
    var base64ImageData: String?
    
    var editing: Bool = false
}
