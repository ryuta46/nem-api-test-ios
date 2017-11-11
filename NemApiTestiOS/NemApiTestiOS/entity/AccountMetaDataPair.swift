//
//  AccountMetaDataPair.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

struct AccountMetaDataPair : Codable {
    let account: AccountInfo
    let meta: AccountMetaData
}
