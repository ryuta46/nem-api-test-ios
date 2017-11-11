//
//  ConvertUtil.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation


class ConvertUtil {
    static func toHexString(_ bytes : [UInt8]) -> String {
        var result = ""
        bytes.forEach { (element) in
            result = result + String(element, radix: 16)
        }
        return result
    }

    static func toByteArray(_ s: String) -> [UInt8] {
        let len = s.lengthOfBytes(using: .ascii)
        var data: [UInt8] = []
        for i in stride(from:0, to:len, by: 2) {
            let startIndex = s.index(s.startIndex, offsetBy: i)
            let endIndex = s.index(startIndex, offsetBy: 2)
            if let val = UInt8(s[startIndex..<endIndex], radix: 16) {
                data.append(val)
            }
        }
        return data
    }

    static func toNativeArray(_ bytes: [UInt8]) -> UnsafeMutablePointer<UInt8> {
        let ret = UnsafeMutablePointer<UInt8>.allocate(capacity: bytes.count)

        for i in 0..<bytes.count {
            ret[i] = bytes[i]
        }
        return ret
    }
    static func toArray(_ native: UnsafePointer<UInt8>,_ size: Int) -> [UInt8] {
        var ret = [UInt8](repeating: 0, count: size)

        for i in 0..<size {
            ret[i] = native[i]
        }
        return ret
    }


    static func toByteArrayWithLittleEndian(_ value: UInt32) -> [UInt8] {
        var ret = [UInt8](repeating: 0, count: 4)

        for i in 0..<ret.count {
            ret[i] = UInt8(value >> (i * 8) & UInt32(0xFF))
        }
        return ret
    }

    static func toByteArrayWithLittleEndian(_ value: UInt64) -> [UInt8] {
        var ret = [UInt8](repeating: 0, count: 8)

        for i in 0..<ret.count {
            ret[i] = UInt8(value >> (i * 8) & UInt64(0xFF))
        }
        return ret
    }
}
