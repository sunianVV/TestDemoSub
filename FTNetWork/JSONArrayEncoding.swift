//
//  JSONArrayEncoding.swift
//  FaceTalk
//
//  Created by WSN on 2021/9/26.
//  解决后台传参是数组的情况

import UIKit
import Alamofire
class JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        
        var request = try urlRequest.asURLRequest()

              guard let json = parameters?["jsonArray"] else {
                  return request
              }

              let data = try JSONSerialization.data(withJSONObject: json, options: [])

              if request.value(forHTTPHeaderField: "Content-Type") == nil {
                  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
              }

              request.httpBody = data

              return request
    }
    

}
