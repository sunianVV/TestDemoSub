//
//  FTTools.swift
//  FaceTalk
//
//  Created by scw on 2021/10/20.
//

import Toast_Swift
import UIKit

class FTTools: NSObject {
    class func codeImageForString(_ string: String) -> UIImage {
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = string.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        let outPutImage = filter?.outputImage
        var codeImage = getHDImgWithCIImage(outPutImage!, size: CGSize(width: 150, height: 150))
        codeImage = imagewithBGImage(codeImage, avatarImage: UIImage(named: "Image_logo"), size: CGSize(width: 150, height: 150))
        return codeImage
    }

    private class func getHDImgWithCIImage(_ img: CIImage, size: CGSize) -> UIImage {
        let pointColor = UIColor.black
        let backgroundColor = UIColor.white
        let colorFilter = CIFilter(name: "CIFalseColor", parameters: ["inputImage": img, "inputColor0": CIColor(cgColor: pointColor.cgColor), "inputColor1": CIColor(cgColor: backgroundColor.cgColor)])
        let qrImage = colorFilter?.outputImage
        // 绘制
        let cgImage = CIContext(options: nil).createCGImage(qrImage!, from: qrImage!.extent)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .none
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.draw(cgImage!, in: context!.boundingBoxOfClipPath)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return codeImage!
    }

    private class func imagewithBGImage(_ bgImage: UIImage, avatarImage: UIImage?, size: CGSize) -> UIImage {
        if avatarImage == nil {
            return bgImage
        }
        let opaque = true
        let scale = UIScreen.main.scale
        let bgRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let avatarWidth = size.width / 4.0
        let avatarHeight = avatarWidth
        let avatarImage2 = clipCornerRadius(avatarImage!, size: CGSize(width: avatarWidth, height: avatarHeight))
        let position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        let avatarRect = CGRect(x: position.x - (avatarWidth / 2.0), y: position.y - (avatarHeight / 2.0), width: avatarWidth, height: avatarHeight)
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.draw(bgImage.cgImage!, in: bgRect)
        context?.draw(avatarImage2.cgImage!, in: avatarRect)
        context?.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    private class func clipCornerRadius(_ image: UIImage, size: CGSize) -> UIImage {
        let outerWidth = size.width / 15.0
        let innerWidth = outerWidth / 10.0
        let corenerRadius = size.width / 5.0
        let areaRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let areaPath = UIBezierPath(roundedRect: areaRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: corenerRadius, height: corenerRadius))
        let outerOrigin = outerWidth / 2.0
        let innerOrigin = innerWidth / 2.0 + outerOrigin / 1.2
        let outerRect = areaRect.insetBy(dx: outerOrigin, dy: outerOrigin)
        let innerRect = outerRect.insetBy(dx: innerOrigin, dy: innerOrigin)
        //  外层path
        let outerPath = UIBezierPath(roundedRect: outerRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: outerRect.size.width / 5.0, height: outerRect.size.width / 5.0))
        //  内层path
        let innerPath = UIBezierPath(roundedRect: innerRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: innerRect.size.width / 5.0, height: innerRect.size.width / 5.0))

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.addPath(areaPath.cgPath)
        context?.clip()
        context?.addPath(areaPath.cgPath)
        let fillColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        context?.setFillColor(fillColor.cgColor)
        context?.fillPath()
        // 画头像
        context?.draw(image.cgImage!, in: innerRect)
        context?.addPath(outerPath.cgPath)
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(outerWidth)
        context?.strokePath()
        context?.addPath(innerPath.cgPath)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(innerWidth)
        context?.strokePath()

        context?.restoreGState()
        let radiusImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return radiusImage!
    }

    class func ToastMessage(_ message: String) {
    }
}
