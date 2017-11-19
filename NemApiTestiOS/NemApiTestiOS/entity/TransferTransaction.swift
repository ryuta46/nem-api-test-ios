//
//  TransferTransaction.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

class TransferTransaction: SignedTransaction {
    // 設定必須
    let receiverAddress: String
    let amount: UInt64 // マイクロNEM単位の数量

    // デフォルト設定のあるパラメータ
    var messagePayload: String = ""
    var messageType: MessageType = .Plain

    init(publicKey: [UInt8], receiverAddress: String, amount: UInt64) {
        self.receiverAddress = receiverAddress
        self.amount = amount

        super.init(type: .Transfer, publicKey: publicKey)
    }

    var transactionBytes: [UInt8] {
        get {
            let commonField = getCommonTransactionBytes(minimumFee: calculateMinimumTransactionFee())
            let messageBytes: [UInt8]
            if !messagePayload.isEmpty {
                // メッセージフィールド長は messageType長(4バイト) + messagePayload長(4バイト) + messagePayload
                let payloadBytes: [UInt8] = Array(messagePayload.utf8)
                let fieldLength = 4 + 4 + payloadBytes.count

                messageBytes = ConvertUtil.toByteArrayWithLittleEndian(UInt32(fieldLength)) +
                    ConvertUtil.toByteArrayWithLittleEndian(messageType.rawValue) +
                    ConvertUtil.toByteArrayWithLittleEndian(UInt32(payloadBytes.count)) +
                    payloadBytes
            } else {
                messageBytes = ConvertUtil.toByteArrayWithLittleEndian(UInt32(0))
            }

            return commonField +
                ConvertUtil.toByteArrayWithLittleEndian(UInt32(receiverAddress.count)) +
                Array(receiverAddress.utf8) as [UInt8] +
                ConvertUtil.toByteArrayWithLittleEndian(amount) +
                messageBytes +
                ConvertUtil.toByteArrayWithLittleEndian(UInt32(0)) // Mosaic 数

        }
    }
    /**
     * 最小の転送トランザクション手数料を計算する
     */
    func calculateMinimumTransactionFee() -> UInt64 {
        // v0.6.93 ベース
        // 10000 XEM 毎に手数料 0.05 xem
        // 最低手数料は 0.05xem
        // 上限は 1.25 xem
        // メッセージがある場合、0.05 xem 開始で メッセージ長 32バイト毎に 0.05xem

        // 以降全てマイクロNEMで計算する
        // 10_000_000_000 毎に 50_000
        // 最低手数料は 50_000
        // 上限は 1_250_000
        // メッセージがある場合、50_000 開始で メッセージ長 32バイト毎に 50_000
        let xemTransferFee = max(50_000, min(((amount / 10_000_000_000) * 50_000) , 1_250_000))
        let messageTransferFee = messagePayload.count > 0 ? 50_000 * UInt64(1 + messagePayload.lengthOfBytes(using: .utf8) / 32) : 0
        return xemTransferFee + messageTransferFee
    }
}

//abstract

