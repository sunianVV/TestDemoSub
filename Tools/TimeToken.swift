//
//  TimeToken.swift
//  project
//
//  Created by EBIZHZ1 on 2018/10/17.
//  Copyright © 2018年 EBIZHZ1. All rights reserved.
//

import UIKit

class TimeToken: NSObject {
    class func getStringTimetoken() -> String {
        // 获取当前时间
        let now = NSDate()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return String(timeStamp)
    }

    // 获取当前时间:精度 时分秒
    class func gettimetoken() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        dateformatter.locale = locale
        let locationString = dateformatter.string(from: Date())
        return locationString
    }

    // 获取当前时间:精度 年月日
    class func getdaytimetoken() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        dateformatter.locale = locale
        let locationString = dateformatter.string(from: Date())
        return locationString
    }

    // 获取当前时间:精度 年月
    class func getMonthTimetoken() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyyMM"
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        dateformatter.locale = locale
        let locationString = dateformatter.string(from: Date())
        return locationString
    }

    // 获取距1970年的时间
    class func get1970timetoken() -> String {
        let date = Date()
        let timeInterval = date.timeIntervalSince1970 * 1000
        let str: NSString = "\(timeInterval)" as NSString
        let locationString = str.substring(to: 13)
        return locationString
    }

    // 获取当前时间戳
    class func getNowTimeToken() -> String {
        let now = NSDate()
        let timeInterval: TimeInterval = now.timeIntervalSince1970
        let timeStamp: String = String(timeInterval)
        return timeStamp
    }

    // 时间戳转换时间
    class func timeTokenToTime(timeToken: String) -> String {
        let timeSta: TimeInterval = Double(timeToken)!
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "M月d日"
        let date = Date(timeIntervalSince1970: timeSta)
        let time = dateformatter.string(from: date)
        return time
    }

    // 时间戳转换时间
    class func timeTokenToYearTime(timeToken: String) -> String {
        guard let times = Double(timeToken) else { return "1970年01月01日" }

        let timeSta: TimeInterval = timeToken.count == 13 ? times / 1000 : times

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日"
        let date = Date(timeIntervalSince1970: timeSta)
        let time = dateformatter.string(from: date)
        return time
    }

    // 时间戳转换时间
    class func timeTokenToTimeFormat(_ format: String, timeToken: String) -> String {
        var timeSta: TimeInterval = Double(timeToken)!
        if timeToken.count == 13 {
            timeSta = timeSta / 1000
        }
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let date = Date(timeIntervalSince1970: timeSta)
        let time = dateformatter.string(from: date)
        return time
    }

    // 时间转时间戳
    class func timeToToken(_ str: String) -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: str)
        let dateStamp: TimeInterval = date?.timeIntervalSince1970 ?? 0
        let dateSt: Int = Int(dateStamp)
        return String(dateSt)
    }

    // 时间转时间戳
    class func timeToTokenFormart(_ time: String, formart: String) -> Int {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = formart
        let date = dfmatter.date(from: time)
        let dateStamp: TimeInterval = date?.timeIntervalSince1970 ?? 0
        let dateSt: Int = Int(dateStamp * 1000)
        return dateSt
    }

    // 时间格式转换
    class func timeToNewTimeFormart(_ time: String, formart: String, newFormart: String) -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = formart
        let date = dfmatter.date(from: time) ?? Date()

        let newfmatter = DateFormatter()
        newfmatter.dateFormat = newFormart

        let dateSt = newfmatter.string(from: date)
        return dateSt
    }

    // 获取星期几 串入参数为时间戳格式的string
    class func getWeekday(timeToken: String) -> String {
        let timeSta: TimeInterval = Double(timeToken)!
        let date = Date(timeIntervalSince1970: timeSta)
        let calendar = Calendar(identifier: Calendar.Identifier.chinese)
        let components: DateComponents = calendar.dateComponents([.weekday], from: date)
        let weekArr = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return components.weekday == nil ? "" : weekArr[components.weekday! - 1]
    }

    // 获取今天星期几
    class func getTodayWeek() -> String {
        return getWeekday(timeToken: getNowTimeToken())
    }

    // 获取当前年份
    class func getYearTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "Y"
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        dateformatter.locale = locale
        let locationString = dateformatter.string(from: Date())
        return locationString
    }

    // 获取当前月份
    class func getMouthTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "M"
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        dateformatter.locale = locale
        let locationString = dateformatter.string(from: Date())
        return locationString
    }

    // 获取当前日期
    class func getDayTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "d"
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        dateformatter.locale = locale
        let locationString = dateformatter.string(from: Date())
        return locationString
    }

    // 获取当前小时
    class func getHourTime() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "H"
        let locale = Locale(identifier: Locale.preferredLanguages[0])
        dateformatter.locale = locale
        let locationString = dateformatter.string(from: Date())
        return locationString
    }

    class func getWeekNum(weekDay: String) -> Int {
        switch weekDay {
        case "周一":
            return 1
        case "周二":
            return 2
        case "周三":
            return 3
        case "周四":
            return 4
        case "周五":
            return 5
        case "周六":
            return 6
        case "周日":
            return 7
        default:
            return 0
        }
    }

    // 获取本周一凌晨的时间戳
    class func getMondayMoringTimeInterval() -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nowDate = dateFormatter.date(from: TimeToken.getdaytimetoken())
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "zh_CN")
        let comp = calendar.dateComponents([.year, .month, .day, .weekday], from: nowDate!)

        // 获取今天是周几
        let weekDay = comp.weekday
        // 获取几天是几号
        let day = comp.day

        // 计算当前日期和本周的星期一和星期天相差天数
        var firstDiff: Int
        if weekDay == 1 {
            firstDiff = -6
        } else {
            firstDiff = calendar.firstWeekday - weekDay! + 1
        }

        // 在当前日期(去掉时分秒)基础上加上差的天数
        var firstDayComp = calendar.dateComponents([.year, .month, .day], from: nowDate!)
        firstDayComp.day = day! + firstDiff
        let firstDayOfWeek = calendar.date(from: firstDayComp)
        let firstDay = dateFormatter.string(from: firstDayOfWeek!)

        let firstDate = dateFormatter.date(from: firstDay)
        let dateStamp: TimeInterval = firstDate!.timeIntervalSince1970
        return Double(dateStamp)
    }
}
