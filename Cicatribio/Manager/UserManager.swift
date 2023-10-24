//
//  UserManager.swift
//  Cicatribio
//
//  Created by Gustavo Costa on 23/10/23.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    var currentUser: User?
    var hygieneTypes: [HygieneType]?
    var symptomsTypes: [SymptomType]?
    var injurySites: [InjurySite]?
    var exudateTypes: [ExudateType]?
    var exudateAmounts: [ExudateAmount]?
    var selfCareTypes: [SelfCareType]?
    var mobilityTypes: [MobilityType]?
    var skinTypes: [SkinType]?
    
    private init() {}
}
