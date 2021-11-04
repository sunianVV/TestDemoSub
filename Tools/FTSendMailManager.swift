//
//  FTSendMailManager.swift
//  FaceTalk
//
//  Created by scw on 2021/10/21.
//

import MessageUI
import UIKit

class FTSendMailManager: NSObject {
    var title: String!
    var sendStatus = { (_: MFMailComposeResult) in
    }

    // 单例
    static var shared: FTSendMailManager {
        struct SingleStruct {
            static let instance: FTSendMailManager = FTSendMailManager()
        }
        return SingleStruct.instance
    }

    override private init() {}

    func sendMail(_ title: String, andMessage message: String, vc: UIViewController, receive mail: String) {
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "温馨提示", message: "当前未配置邮箱,是否去配置?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in

            }))
            alert.addAction(UIAlertAction(title: "去设置", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: "mailto://")!, options: [:], completionHandler: nil)
            }))
            vc.present(alert, animated: true, completion: nil)
            return
        }
        let mailcontroller = MFMailComposeViewController()
        mailcontroller.mailComposeDelegate = self
        mailcontroller.setSubject(title)
        if mail.count > 0 {
            mailcontroller.setToRecipients([mail])
        }

        FTSendMailManager.shared.title = title
        let emailBody = message
        mailcontroller.setMessageBody(emailBody, isHTML: true)
        vc.present(mailcontroller, animated: true, completion: nil)
    }
}

extension FTSendMailManager: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        sendStatus(result)
        controller.dismiss(animated: true, completion: nil)
    }
}
