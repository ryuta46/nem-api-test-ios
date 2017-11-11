//
//  SignedTransaction.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

class SignedTransaction {
    let type: TransactionType
    let publicKey: [UInt8]

    var version: Version = .Main
    var fee: UInt64 = 0// マイクロNEM単位の手数料

    init(type: TransactionType, publicKey: [UInt8]) {
        self.type = type
        self.publicKey = publicKey
    }

    func getCommonTransactionBytes(minimumFee: UInt64) -> [UInt8] {
        // タイムスタンプ計算
        let timestamp = TimeUtil.currentTimeFromOrigin()
        // deadline はそこから 1 時間後にする
        let deadline = timestamp + 60 * 60

        let transactionFee = max(minimumFee, fee)

        return ConvertUtil.toByteArrayWithLittleEndian(type.rawValue) +
            ConvertUtil.toByteArrayWithLittleEndian(version.rawValue + type.versionOffset) +
            ConvertUtil.toByteArrayWithLittleEndian(timestamp) +
            ConvertUtil.toByteArrayWithLittleEndian(UInt32(publicKey.count)) +
            publicKey +
            ConvertUtil.toByteArrayWithLittleEndian(transactionFee) +
            ConvertUtil.toByteArrayWithLittleEndian(deadline)
    }
}
