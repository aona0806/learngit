//
//  SplashManager.swift
//  news
//
//  Created by chunhui on 16/3/22.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class SplashManager: NSObject {

    private static let adDuration = 4.0
    
    static let  instance = SplashManager()
    var adModel : LJAdModel? = nil
    class func sharedInstance() -> SplashManager {
        return instance
    }
    
    func checkShowSplash(){
        self.loadCacheAdModel()
        if self.adModel == nil || self.adModel?.data?.count == 0 {
            self.requestAd()
        }else if self.checkAndDownloadAdImages() {
            self.tryShowSplash()
            self.requestAd()//加载新的内容
        }
    }
    
    
    private func tryShowSplash(){
        
        guard let ad = adModel else {
            return
        }
        
        if ad.data.count > 0 {
            
            let adView = AdSplashView.adView(ad)
            
            adView.show(Double(SplashManager.adDuration))
            
            adView.dismiss(true, afterDely: SplashManager.adDuration*(Double)(self.adModel!.data!.count))
        }

    }
    
    
    private func loadCacheAdModel(){
        
        let path = self.adCachePath()
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            
            do {
                try  self.adModel = LJAdModel(data: data)
            }catch _ as NSError {
                
            }
        }
        
    }
    
    
    private func requestAd(){
        
        
        TKRequestHandler.sharedInstance().getAdPos(.splash, count: 0) {[weak self] (task, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            if error != nil || model?.data == nil {
                return
            }
            guard let ads = model?.data as? [LJAdDataModel] else {
                
                strongSelf.adModel = nil
                strongSelf.saveAdModel()
                return
                
            }
            
            if ads.count > 0 {
                
                for  ad in ads {
                    
                    guard  let imgUrl = ad.imgUrl else {
                        return
                    }
                    
                    if imgUrl.length() == 0 {
                        //下载的广告有问题
                        return
                    }
                }
                
                strongSelf.adModel = model
                strongSelf.saveAdModel()
                _ = strongSelf.checkAndDownloadAdImages()
                
            }else{
                
                //没有配置广告
                strongSelf.adModel = nil
                strongSelf.saveAdModel()
                
            }
            
         
        }
        
    }
    
    /**
     判断广告图片是否下载完毕，若没有 再继续下载
     
     - returns: true 完毕 false 没有
     */
    private func checkAndDownloadAdImages() -> Bool {
        
        guard let ad = adModel else {
            return false
        }
        if let adDatas = ad.data as? [LJAdDataModel] {
            var imgUrls = [URL]()
            for data in adDatas {
                if let url = Urlhelper.tryEncode(data.imgUrl){
                    
                    if !SDWebImageManager.shared().cachedImageExists(for: url) {
                        imgUrls.append(url)
                    }
                }
            }
            if imgUrls.count > 0 {
                SDWebImagePrefetcher.shared().prefetchURLs(imgUrls, progress: nil, completed: {[weak self] (ok, sikped) in
                    if sikped > 0 {
                        //图片有无效的图片，重新请求广告
                        self?.adModel = nil
                        self?.saveAdModel()
                    }
                })
                
                return false
                
            }
        }
        
        return true
        
    }
    
    
    private func adCachePath() -> String{
        
        return TKFileUtil.path(forDir: TKFileUtil.cachePath(), pathComponent: "splash.dat")
    }
    
    private func saveAdModel() {
        
        guard let ad = self.adModel else {
            
            //清除本地缓存
            let path = self.adCachePath()
            TKFileUtil.removeFiles(atPath: path)
            
            return
        }
        
        let path = self.adCachePath()
        let str = ad.toJSONString()
        do {
          try  str?.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        }catch _ as NSError {
            
        }
        
    }
    
}
