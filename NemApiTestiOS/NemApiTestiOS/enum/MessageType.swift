//
//  MessageType.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

enum MessageType: UInt32 {
    case Plain = 1 // 平文
    case Encrypted = 2 // 暗号文
}
