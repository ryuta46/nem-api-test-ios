//
//  AccountMetaData.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

struct AccountMetaData : Codable {
    let status: String
    let remoteStatus: String
    let cosignatoryOf: [AccountInfo]
    let cosignatories: [AccountInfo]
}
