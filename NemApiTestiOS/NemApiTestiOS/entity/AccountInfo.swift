//
//  AccountInfo.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

struct AccountInfo: Codable {
    let address: String
    let balance: Int
    let vestedBalance: Int
    let importance: Double
    let publicKey: String
    let label: String?
    let harvestedBlocks: Int
}
