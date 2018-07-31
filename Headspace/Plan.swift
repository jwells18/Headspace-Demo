//
//  Plan.swift
//  Headspace
//
//  Created by Justin Wells on 7/31/18.
//  Copyright © 2018 SynergyLabs. All rights reserved.
//

import Foundation

class Plan: NSObject{
    var objectId: String!
    var createdAt = Double()
    var updatedAt = Double()
    var name: String!
    var price = Double()
    var promotionalDetail: String!
    var period: Int!
    var periodName: String!
    var priority: Int!
}
