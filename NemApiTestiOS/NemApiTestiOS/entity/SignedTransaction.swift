//
//  SignedTransaction.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

struct SignedTransaction {
    let type: TransactionType
    let version: Version
    let publicKey: [UInt8]
    let fee: UInt64 // マイクロNEM単位の手数料

    /*
    var commonTransactionBytes: [UInt8] {
        get {
            // タイムスタンプ計算
            val timestamp = TimeUtil.currentTimeFromOrigin()
            // deadline はそこから 1 時間後にする
            val deadline = timestamp + 60 * 60

            val transactionFee = Math.max(calculateMinimumTransactionFee(), fee)
            return toByteArrayWithLittleEndian(type.rawValue) +
                toByteArrayWithLittleEndian(version.rawValue + type.versionOffset) +
                toByteArrayWithLittleEndian(timestamp) +
                toByteArrayWithLittleEndian(publicKey.size) +
                publicKey +
                toByteArrayWithLittleEndian(transactionFee) +
                toByteArrayWithLittleEndian(deadline)
    }

    /**
     * 最小の転送トランザクション手数料を計算する
     */
    abstract fun calculateMinimumTransactionFee() : Long
 */

}
