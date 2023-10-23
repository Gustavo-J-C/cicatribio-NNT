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
    var mobilityTypes: [MobilityType]?
    var skinTypes: [SkinType]?
    
    private init() {}
}
