//
//  NetWork.swift
//  MoyaTest
//
//  Created by WSN on 2021/7/14.
//

import Moya
import Alamofire
import SVProgressHUD

///******************************* 发送网络请求 *******************************
struct Network {
    
    // 定义一个provider（请求发起者）, 并设置超时时间、使用HUD插件
    static let Provider = MoyaProvider<API>(requestClosure: requestTimeoutClosure, plugins: [HUDPlugin()])
 
    // 以下回调参数，应根据自己公司服务器返回格式进行自定义
    typealias successCallback = (([String:Any], Int, String) -> Void) // 服务器返回的数据，最外层统一格式是字典
    typealias failureCallback = ((Int, String) -> Void)
    typealias errorCallback   = ((Int, String) -> Void)
    static func request ( _ target: API,
                          success successCallback: @escaping successCallback,
                          failure failureCallback: @escaping failureCallback,
                          error errorCallback: @escaping errorCallback) {
        
        if !UIDevice.isNetworkConnect {
            SVProgressHUD.showInfo(withStatus: "网络似乎出现了问题")
            return
        }
        
        Provider.request(target){ result in
            switch result {
            case let .success(response):
                do {
                    //过滤成功状态码（200 - 299)。 (404、401、500等，这些就直接走catch）
                    _ = try response.filterSuccessfulStatusCodes()
                    let dic = try response.mapJSON() as? [String : Any]
                    let code = response.statusCode
                    let msg = JSON(dic ?? [:])["message"].stringValue
                    successCallback(dic ?? [:], code, msg)
                    // 可以在这里做 、用户登录已过期 、强制更新
 
                } catch {

                    let err = error as! MoyaError
                    if case let .statusCode(response) = err {
                        
                        errorCallback(response.statusCode, response.description)
                        
                        let errDetails = try? response.mapJSON() as? [String:Any]
                        print("⚠️⚠️⚠️⚠️⚠️⚠️错误详情： ", "状态码：",response.statusCode, " |  错误内容：", (errDetails ?? [:]))
                    }
                 }
                
            case let .failure(error):
                // 服务器连接不上
                failureCallback(error.errorCode, error.errorDescription ?? "noMessage")
            }
        }
    }
}


///******************************* 设置请求超时时间 ****************************
let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<API>.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 10
        done(.success(request))
    } catch MoyaError.requestMapping(let url) {
        done(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        done(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}


///******************************* 设置自定义插件 ******************************
struct HUDPlugin: PluginType {
    // 开始发起请求
    func willSend(_ request: RequestType, target: TargetType) {
        if let target = target as? FTTargetType, target.showHUD == true {
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
        }
    }
    
    // 收到请求
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if let target = target as? FTTargetType, target.showHUD == true {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        }

        // 只有请求错误时会继续往下执行
        guard case let Result.failure(error) = result else { return }

        // 弹出并显示错误信息
//        let message = error.errorDescription ?? "未知错误"
//        SVProgressHUD.show(withStatus: message)
    }
}


///******************************* 基于Alamofire,网络是否连接 ******************
extension UIDevice {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true // 无返回就默认网络已连接
    }
}
