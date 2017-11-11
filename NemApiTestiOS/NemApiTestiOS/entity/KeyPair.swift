//
//  KeyPair.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

struct KeyPair {
    let publicKey: [UInt8]
    let privateKey: [UInt8]
    let privateKeySeed: [UInt8]
}
