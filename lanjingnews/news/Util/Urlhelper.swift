//
//  Urlhelper.swift
//  news
//
//  Created by 陈龙 on 16/6/14.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class Urlhelper: NSObject {
    
    /**
     urlString 编码
     
     - parameter urlString: <#urlString description#>
     
     - returns: <#return value description#>
     */
    static func tryEncode(_ urlString: String?) -> URL? {
        
        guard let urlStr = urlString else {
            return nil
        }
        
        var url: URL? = URL(string: urlStr)
        if url == nil {
            url = urlStr.encodeURL()
        }
        return url
            
    }
}
