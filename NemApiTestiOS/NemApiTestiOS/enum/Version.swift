//
//  Version.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

enum Version: UInt32 {
    // トランザクション種別による加算値(+1, +2) は rawValue として含めない。
    // メインネットワーク
    case Main = 0x68000000
    // テストネットワーク
    case Test = 0x98000000
}
