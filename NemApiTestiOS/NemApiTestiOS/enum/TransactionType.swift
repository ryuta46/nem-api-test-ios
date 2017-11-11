//
//  TransactionType.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

enum  TransactionType: UInt32 {
    // 転送トランザクション
    case Transfer = 0x0101
    // 重要度転送トランザクション)
    case ImportanceTransfer = 0x0801
    // マルチシグ集計変更転送トランザクション
    case MultisigAggregateModificationTransfer = 0x1001
    // マルチシグ署名トランザクション)
    case MultisigSignature = 0x1002
    // マルチシグトランザクション
    case Multisig = 0x1004
    // プロキシネームスペーストランザクション
    case ProvisionNamespace = 0x2001
    // モザイク定義作成トランザクション
    case MosaicDefinitionCreation = 0x4001
    // モザイク供給変更トランザクション
    case MosaicSupplyChange = 0x4002


    var versionOffset: UInt32 {
        get {
            switch self {
            case .Transfer, .MultisigAggregateModificationTransfer:
                return 2
            default:
                return 1
            }
        }
    }
}
