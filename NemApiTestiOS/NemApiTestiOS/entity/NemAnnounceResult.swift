//
//  NemAnnounceResult.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

struct NemAnnounceResult : Codable{
    let type: Int
    let code: Int
    let message: String
    let transactionHash: TransactionData?
    let innerTransactionHash: TransactionData?

    struct TransactionData : Codable {
        var data: String? = nil
    }

}
