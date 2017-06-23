//
//  RestAPIUtil.swift
//  Lost In Time
//
//  Created by Toby Hsu on 2017/6/23.
//  Copyright © 2017年 Orav. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON

enum WhitmanError: Int {
    case userNotFound = 1002
    case userExisted = 1003
    case invalidKey = 1050
    case invalidParameters = 1051
    case invalidSessionToken = 1052

    var domain: String {
        switch self {
        case .userNotFound: return "user not found"
        case .userExisted: return "user existed"
        case .invalidKey: return "invalid key"
        case .invalidParameters: return "invalid parameters"
        case .invalidSessionToken: return "invalid session token"
        }
    }
    var error: NSError {
        return NSError(domain: self.domain, code: self.rawValue, userInfo: nil)
    }
}

class RestAPIUtil {
    static var share = RestAPIUtil()
    private let apiURL = "https://whitman9453.azurewebsites.net/1"
    private let restKey = "1317f83b74067b835f3f8a2e86da0bd2d2006196efa77b7f0511096e68a9b0e7"
    
    func createImgurURL(with data: Data) -> Promise<String> {
        return Promise(resolvers: { (fulfill, reject) in
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append("JEHbd".data(using: .utf8)!, withName: "album")
                multipartFormData.append(data, withName: "image")
            }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: "https://api.imgur.com/3/image", method: .post, headers: ["authorization": "Bearer 0fbf751b1fb595f0e333069936f8840c5c7005a8", "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"]) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let error = response.result.error {
                            reject(error)
                            print(error)
                        } else {
                            let json = JSON(response.result.value!)
                            fulfill(json["data"]["link"].stringValue)
                            debugPrint(response)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        })
    }
    
    func createUser(with name: String, _ mail: String) -> Promise<String> {
        return Promise(resolvers: { (fulfill, reject) in
            Alamofire.request("\(apiURL)/createUser", method: .post, parameters: ["email": mail, "displayName": name], encoding: JSONEncoding.default, headers: ["x-whitman-rest-key": restKey, "content-type": "application/json"]).responseJSON { (response) in
                if let error = response.error {
                    reject(error)
                    print(error)
                } else {
                    let json = JSON(response.result.value!)
                    if let code = json["code"].int, let err = WhitmanError(rawValue: code) {
                        reject(err as! Error)
                    } else {
                        if let token = json["token"].string {
                            fulfill(token)
                        } else {
                            reject(NSError(domain: "unknow exception", code: -1, userInfo: nil))
                        }
                    }
                    debugPrint(response)
                }
            }
        })
    }
}
