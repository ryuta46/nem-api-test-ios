//
//  CryptoUtil.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation


class CryptoUtil {

    private static let PUBLIC_KEY_SIZE = 32
    private static let PRIVATE_KEY_SIZE = 64
    private static let PRIVATE_KEY_SEED_SIZE = 32
    private static let SIGNATURE_SIZE = 64

    private static let PRIVATE_KEY = "PRIVATE_KEY"
    /**
     * キーペアを読み込む。キーが保存されていない場合はキーを新たに作成する
     */
    static func loadKeys() -> KeyPair {
        var privateKeySeed: [UInt8] = []
        let defaults = UserDefaults.standard
        if let saved = defaults.object(forKey: PRIVATE_KEY) as? [UInt8] {
            privateKeySeed = saved
        } else {
            let nativeSeed = UnsafeMutablePointer<UInt8>.allocate(capacity: PRIVATE_KEY_SEED_SIZE)
            ed25519_create_seed(nativeSeed)
            privateKeySeed = ConvertUtil.toArray(nativeSeed, PRIVATE_KEY_SEED_SIZE)

            // TODO: 本来は暗号化などして保存すべき
            defaults.setValue(privateKeySeed, forKey: PRIVATE_KEY)
        }
        let privateKey = UnsafeMutablePointer<UInt8>.allocate(capacity: PRIVATE_KEY_SIZE)
        let publicKey = UnsafeMutablePointer<UInt8>.allocate(capacity: PUBLIC_KEY_SIZE)


        ed25519_sha3_create_keypair(publicKey, privateKey,
                                    ConvertUtil.toNativeArray(privateKeySeed))

        let publicKeyString = ConvertUtil.toHexString(ConvertUtil.toArray(publicKey, PUBLIC_KEY_SIZE))

        //print("wallet import privateKey: \(ConvertUtil.toHexString(ConvertUtil.swapByteArray(privateKeySeed)))")
        print("publicKey: \(publicKeyString)")

        let kv = KeyPair(
            publicKey: ConvertUtil.toArray(publicKey, PUBLIC_KEY_SIZE),
            privateKey: ConvertUtil.toArray(privateKey, PRIVATE_KEY_SIZE),
            privateKeySeed: privateKeySeed)

        // 一応署名と検証ができるか検証しておく
        try! validateKeyPair(kv)
        return kv
    }


    static func validateKeyPair(_ kv: KeyPair) throws {
        // 適当にランダムなバイト列を生成し、署名と検証を行う
        var message:[UInt8] = [UInt8](repeating: 0, count: 256)
        for i in 0..<message.count {
            message[i] = UInt8(arc4random_uniform(256))
        }

        let signature = sign(kv, message)
        if verify(kv, message, signature) {
            print("Verify OK")
        } else {
            print("Verify NG")
            throw NSError(domain:"Failed to validate key pair", code: -1, userInfo: nil)
        }
    }

    /**
     * 署名バイト列を返す
     */
    static func sign(_ kv: KeyPair, _ message: [UInt8]) -> [UInt8] {
        let signature = UnsafeMutablePointer<UInt8>.allocate(capacity: SIGNATURE_SIZE)

        ed25519_sha3_sign(signature,
                          ConvertUtil.toNativeArray(message),
                          message.count,
                          ConvertUtil.toNativeArray(kv.publicKey),
                          ConvertUtil.toNativeArray(kv.privateKey))

        return ConvertUtil.toArray(signature, SIGNATURE_SIZE)
    }

    /**
     * 署名を検証する
     */
    static func verify(_ kv: KeyPair, _ message: [UInt8], _ signature: [UInt8]) -> Bool {

        return ed25519_sha3_verify(ConvertUtil.toNativeArray(signature),
                          ConvertUtil.toNativeArray(message),
                          message.count,
                          ConvertUtil.toNativeArray(kv.publicKey)) > 0
    }



}
