//
//  ImageUploadManager.swift
//  news
//
//  Created by chunhui on 15/12/24.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class ImageUploadManager: NSObject {
    
    static func uploadImage(_ image : UIImage ,fileName : String , completion:@escaping (_ task : URLSessionDataTask? , _ url : String? , _ errMsg : String?)->()) -> URLSessionDataTask? {
        
        let request = "\(NetworkManager.api2Host())/upload/img"
        
        let data = UIImageJPEGRepresentation(image, 0.8)
        
        return TKRequestHandler.sharedInstance().postRequest(forPath: request, param: nil, formData: { (formData) -> Void in
            
            let mimeType = NSData.sd_contentType(forImageData: data!) ?? ""
            formData?.appendPart(withFileData: data!, name: "file", fileName: "image.png", mimeType: mimeType)
//            formData.appendPart(fileData: data!, name: "file", fileName: "image.png", mimeType: mimeType)
            }, finish: { (task, response, error) -> Void in
                
                var url = ""
                var msg = ""
                
                if let resDict = response as? Dictionary<String , AnyObject> {
                    
                    if  let data = resDict["data"] as? Dictionary<String,String> {
                        
                        url = data["url"]! as String
                        
                    }else if response != nil {
                        
                        if let errMsg =  resDict["msg"] as? String {
                            msg = errMsg
                        }
                    }
                }else if error != nil {
                    
                    msg = error!._domain
                }
                
                completion(task,url,msg)
        })
        

        
        
    }
    
}
