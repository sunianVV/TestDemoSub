//
//  FTRouter.swift
//  FaceTalk
//
//  Created by scw on 2021/9/29.
//

import EventKit
import MessageUI
import UIKit

@objcMembers class FTRouter: NSObject {
    class func HandleJSApis(_ param: NSDictionary, context: PSDContext, callBack: @escaping PSDJsApiResponseCallbackBlock) {
        let funcName = JSON(param)["funcName"].stringValue
        switch funcName {
        case "netWork": // 接口调用
            // 判断参数是否正常
            var isValid = false
            if let _sendParam = JSON(param)["sendParam"].string, _sendParam == "null" {
                isValid = true
            }
            if JSON(param)["sendParam"].dictionaryObject != nil {
                isValid = true
            }
            if JSON(param)["sendParam"].arrayObject != nil {
                isValid = true
            }
            let time = TimeToken.gettimetoken()
            if isValid {
                Network.request(API.bridgeRequest(param as! [String: Any])) { dic, code, message in
                    print(dic)
                    callBack(["data": dic, "code": code, "message": message, "requestParam": param, "startTime": time, "endTime": TimeToken.gettimetoken()])
                } failure: { code, message in
//                    print(MoyaError)
                    callBack(["code": code, "message": message, "requestParam": param, "startTime": time, "endTime": TimeToken.gettimetoken()])
                } error: { code, message in
//                    print(errCode)
                    callBack(["code": code, "message": message, "requestParam": param, "startTime": time, "endTime": TimeToken.gettimetoken()])
                }
            } else {
                callBack(["code": -10000, "message": "参数异常", "requestParam": param, "startTime": time, "endTime": TimeToken.gettimetoken()])
            }
            break
        case "shareMini":
            callBack("成功了")
            break
        case "planning": // 创建日程
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { granted, error in
                if let _ = error {
                    callBack(["code": "0", "message": "新增日程失败"])
                } else if !granted {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "温馨提示", message: "请允许赢家友约访问您的日历,以便添加日程提醒", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                            callBack("失败")
                        }))
                        alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { _ in
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }))
                        context.currentViewController().present(alert, animated: true, completion: nil)
                    }
                } else {
                    // 允许访问
                    let isAgain = JSON(param)["isAgain"].stringValue
                    let period = Int(JSON(param)["period"].stringValue) ?? 365
                    var count: Int = 1
                    let eventIdAry = JSON(param)["eventIds"].arrayValue
                    let groupId = JSON(param)["groupId"].stringValue
                    if isAgain == "1" { // "1":周期性  "0":非周期性
                        count = 365 / period
                        if let oldGroup = UserDefaults.standard.value(forKey: groupId) as? [String] { // 删除旧的
                            DispatchQueue.main.async {
                                for oldId in oldGroup {
                                    if let event = eventStore.event(withIdentifier: oldId) {
                                        do {
                                            try eventStore.remove(event, span: .thisEvent, commit: true)
                                        } catch {
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        if let oldId = UserDefaults.standard.value(forKey: JSON(eventIdAry)[0].stringValue) as? String { // 删除旧的
                            if let event = eventStore.event(withIdentifier: oldId) {
                                DispatchQueue.main.async {
                                    do {
                                        try eventStore.remove(event, span: .thisEvent, commit: true)
                                    } catch {
                                    }
                                }
                            }
                        }
                    }

                    let date = JSON(param)["time"].stringValue
                    let time = TimeToken.timeToTokenFormart(date, formart: "yyyy-MM-dd HH:mm") / 1000
                    var groupAry = [String]()
                    for i in 0 ..< count {
                        let evevt = EKEvent(eventStore: eventStore)
                        let sDate = time + i * period * 24 * 60 * 60
                        let dateF = DateFormatter()
                        dateF.dateFormat = "yyyy-MM-dd HH:mm"
                        evevt.startDate = Date(timeIntervalSince1970: TimeInterval(sDate))
                        evevt.endDate = Date(timeIntervalSince1970: TimeInterval(sDate + 300))
                        evevt.location = JSON(param)["location"].stringValue
                        evevt.title = JSON(param)["title"].stringValue

                        evevt.calendar = eventStore.defaultCalendarForNewEvents
                        do {
                            try eventStore.save(evevt, span: .thisEvent)
                            groupAry.append(evevt.eventIdentifier)

                            UserDefaults.standard.setValue(evevt.eventIdentifier, forKey: JSON(eventIdAry)[i].stringValue)

                        } catch {
                        }
                    }

                    UserDefaults.standard.setValue(groupAry, forKey: groupId)
                    UserDefaults.standard.synchronize()
                    callBack(["code": "1", "message": "新增日程成功"])
                }
            }

            break
        case "delete_plan":
            let eventStore = EKEventStore()
            if JSON(param)["eventId"].stringValue != "" {
                if let oldId = UserDefaults.standard.value(forKey: JSON(param)["eventId"].stringValue) as? String { // 删除旧的
                    DispatchQueue.main.async {
                        if let event = eventStore.event(withIdentifier: oldId) {
                            do {
                                try eventStore.remove(event, span: .thisEvent, commit: true)
                                callBack(["code": "1", "message": "删除日程成功"])
                            } catch {
                                callBack(["code": "0", "message": "删除日程失败"])
                            }
                        }
                    }
                }
                break
            }
            if JSON(param)["groupId"].stringValue != "" {
                if let oldGroup = UserDefaults.standard.value(forKey: JSON(param)["groupId"].stringValue) as? [String] { // 删除旧的
                    DispatchQueue.main.async {
                        for oldId in oldGroup {
                            if let event = eventStore.event(withIdentifier: oldId) {
                                do {
                                    try eventStore.remove(event, span: .thisEvent, commit: true)
                                } catch {
                                }
                            }
                        }
                        callBack(["code": "1", "message": "删除日程成功"])
                    }
                }
                break
            }
        case "share_wx":
            guard WXApi.isWXAppInstalled() else {
                AUToast.present(within: context.currentViewController().view, with: AUToastIconNone, text: "请先安装微信", duration: 2, logTag: "")
                return
            }
            let req = SendMessageToWXReq()
            if JSON(param)["bText"].stringValue == "1" {
                req.bText = true
                req.text = JSON(param)["text"].stringValue
            } else {
                req.bText = false
                let message = WXMediaMessage()
                message.title = JSON(param)["title"].stringValue
                message.description = JSON(param)["description"].stringValue
                let img = UIImage(named: "img_share")!
                message.thumbData = img.pngData()!
                if JSON(param)["imgUrl"].stringValue != "" {
                    let imgObj = WXImageObject()
                    imgObj.imageData = img.pngData()!
                    message.mediaObject = imgObj
                }

                if JSON(param)["webpageUrl"].stringValue != "" {
                    let webObj = WXWebpageObject()
                    webObj.webpageUrl = JSON(param)["webpageUrl"].stringValue
                    message.mediaObject = webObj
                }
                req.message = message
            }
            req.scene = Int32(JSON(param)["scene"].stringValue)!
            WXApi.send(req) { success in
                print("分享结果\(success)")
                callBack(success ? "分享成功" : "分享失败")
            }
            break
        case "share_test_url":
            guard WXApi.isWXAppInstalled() else {
                FTTools.ToastMessage("请安装微信客户端")
                return
            }
            let req = SendMessageToWXReq()
            req.bText = false
            let message = WXMediaMessage()

            let imgObj = WXImageObject()
            let img = FTTools.codeImageForString(JSON(param)["shareLink"].stringValue)
            imgObj.imageData = img.pngData()!
            message.mediaObject = imgObj

            req.message = message
            req.scene = 0
            WXApi.send(req) { success in
                print("分享结果\(success)")
                if success {
                    callBack(["code": "1", "message": "分享成功"])
                } else {
                    callBack(["code": "0", "message": "分享失败"])
                }
            }
            break
        case "send_email":
            let message = "<b>\(JSON(param)["name"].stringValue)\(JSON(param)["name"].stringValue) 您好，</b><br/><br/><b>欢迎您参加友邦天生赢家测评。开始测评，请点击以下链接：</b><br/><a href =\(JSON(param)["mobileUrl"].stringValue) >\(JSON(param)["mobileUrl"].stringValue)</a><br/><p>此测评链接于3天后 \(JSON(param)["delayTime"].stringValue) 过期。</p><br/><b>请按照屏幕上的说明进行操作。</b><b>如果您在进行评估时遇到任何问题，请与我联系。</b>"
            FTSendMailManager.shared.sendMail("友邦-天生赢家测评", andMessage: message, vc: context.currentViewController(), receive: JSON(param)["receiveMail"].stringValue)
            FTSendMailManager.shared.sendStatus = {
                (result: MFMailComposeResult) in
                if result == .sent {
                    callBack(["code": "1", "message": "发送成功"])
                } else {
                    callBack(["code": "0", "message": "发送失败"])
                }
            }
            break
        case "exit_app":
            exit(1)
            break
        default:
            callBack("没找到")
        }
    }

//    @objc func requestAccessToEntityType(type:String,completion:String){
//
//    }
}
