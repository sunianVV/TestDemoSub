//
//  FTHttpTool.swift
//  FaceTalk
//
//  Created by scw on 2021/9/2.
//

import UIKit

class FTHttpTool: NSObject {
    class func getSettingFlag() -> String {
        if let flag = UserDefaults.standard.value(forKey: "multi_identifier") as? String {
            return flag
        }
        return "sit"
    }
    
    class func getHttpAddress() -> String {
        switch getSettingFlag() {
        case "uat":
            return "https://uat.aia.com.cn/cms/"
        case "prd":
            return "https://aes.aia.com.cn/cms/" 
        default:
            return "http://47.103.7.41:9081/smart-recruit/attractapi/"
        }
    }
}
