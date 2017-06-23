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

class RestAPIUtil {
    static var share = RestAPIUtil()
    
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
}
