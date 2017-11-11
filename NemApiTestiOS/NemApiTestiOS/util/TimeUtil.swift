//
//  TimeUtil.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/12.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import Foundation

class TimeUtil {
    static func currentTimeFromOrigin() -> UInt32 {
        // NEM のネメシスブロック生成日時は 2015/03/29 00:06:25
        // この日時から現在時刻の差分を得る
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        guard let origin = dateFormatter.date(from: "2015/03/29 00:06:25") else {
            print("Failed to parse time string")
            return 0
        }
        return UInt32(-origin.timeIntervalSinceNow)
    }

}
