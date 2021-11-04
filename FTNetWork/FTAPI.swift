//
//  FTAPI.swift
//  MoyaTest
//
//  Created by WSN on 2021/7/14.
//

import UIKit
import Moya


// 接口名
public enum API {
    case bridgeRequest([String:Any])
}


// 请求配置
extension API: FTTargetType {
    /// 是否需要显示HUD
    public var showHUD: Bool {
        switch self {
        case .bridgeRequest:
           return false
        }
    }
 
    /// 服务器地址
    public var baseURL: URL {
        let isOnlineTest = UserDefaults.standard.value(forKey: "online") as? Bool ?? false
        if isOnlineTest == false {
            if let address = UserDefaults.standard.value(forKey: "ipAddress") {
                return URL(string:"http://\(address)/smart-recruit/attractapi/")!
            }
            return URL(string:"http://172.22.66.25:9081/smart-recruit/attractapi/")!
        }else {
             return URL(string: FTHttpTool.getHttpAddress())!
        }
    }
    
    /// 各个请求的具体路径
    public var path: String {
        switch self {
        case let .bridgeRequest(parameter):
            return JSON(parameter)["url"].stringValue
        }
    }
    
    /// 请求类型 GET  POST
    public var method: Moya.Method {
        switch self {
        case let .bridgeRequest(parameter): 
            let type = JSON(parameter)["requestType"].stringValue
            return Moya.Method(rawValue: type)
        }
    }
    
    /// 请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case let .bridgeRequest(parameter):
            
            // 上传图片  fileType = 0 普通上传   1 文件上传
            let fileString = JSON(parameter)["fileType"].stringValue
            if fileString == "1" {
                
                if let param = JSON(parameter)["sendParam"].dictionaryObject {
                    let fileBase64 = JSON(parameter)["fileBase64"].stringValue
                    
                    guard let range = fileBase64.range(of: "base64,") else { return .requestPlain}
                    let location: Int = fileBase64.distance(from: fileBase64.startIndex, to: range.upperBound)
                    let subStr = fileBase64.suffix(fileBase64.count - location)
                    
                    // base64 转 Data
                    let imageData = Data(base64Encoded: String(subStr), options: .ignoreUnknownCharacters)
                    let formData = MultipartFormData(provider: .data(imageData ?? Data()), name: "file", fileName: "file1.jpeg", mimeType: "image/jpeg")
                    return .uploadCompositeMultipart([formData], urlParameters: param)
                    
                }else {
                    let formData = MultipartFormData(provider: .data(Data()), name: fileString, fileName: "file1.jpeg", mimeType: "image/jpeg")
                    return .uploadCompositeMultipart([formData], urlParameters: [:])
                }
                
                
            }else {
                
                if let param = JSON(parameter)["sendParam"].dictionaryObject {
    //                普通请求
                    if JSON(parameter)["requestType"].stringValue == "GET" {
                        return .requestParameters(parameters: param, encoding: URLEncoding.default)
                    }
                    return .requestParameters(parameters: param, encoding: JSONEncoding.default)
                }
                
                
                if let param = JSON(parameter)["sendParam"].arrayObject {
                    return .requestParameters(parameters: ["jsonArray": param], encoding: JSONArrayEncoding.default)
                }
                
                return .requestPlain
            }
             
        }
    }
    
    /// 请求头
    public var headers: [String: String]? {
        switch self {
        default:
            return [
                "model":UIDevice.current.model,
                "os":"android",
                "version": "",
                "deviceId": "",
                "osVersion":"1.1",
//              "Authorization":"Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI3IiwiZXhwIjoxNjI2OTIwODExfQ.mjiV_rxsZq3FV7GbSbWmj174W5SP37PNgjMWNlc4M9Y"
                ]
        }
    }
    
    /// 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    /// 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
}







 
