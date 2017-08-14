//
//  ConfigManager.swift
//  news
//
//  Created by chunhui on 16/1/15.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class ConfigManager: NSObject {

    private static let manager : ConfigManager = ConfigManager()
    
    
    internal private(set) var config : LJConfigDataModel!
    
    private var currentRollRefreshIndex = 0
    
    class func sharedInstance() ->ConfigManager {
        
        return manager
    }
    
    
    override init() {
        
        super.init()
        
        loadConfig()
        
        self.syncConfig()
    }
    
    func loadConfig(){
        
        var path = self.configPath()
        
        var data : Data?
        let fm = FileManager.default
        if !fm.fileExists(atPath: path){
            
            path = Bundle.main.path(forResource: "config.json", ofType:"")!
            
        }
        
        data = try? Data(contentsOf: URL(fileURLWithPath: path))
        do {
            
            try self.config = LJConfigDataModel(data: data!)
            
            if self.config.news == nil {
                path = Bundle.main.path(forResource: "config.json", ofType:"")!
                data = try? Data(contentsOf: URL(fileURLWithPath: path))
                
                try  self.config = LJConfigDataModel(data: data!)
            }
            
        }catch {
            
            print("load config data faield")
        }
    }
    
    func syncConfig(){
        let codeSign = self.config.codeSign ?? ""
        TKRequestHandler.sharedInstance().getAppConfig( withCodesign: codeSign, finish: { [weak self](task, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
//            print(model   , model?.data)
            if  let _ = model  , let appConfig =   model?.data {
                
                if appConfig.hasData && appConfig.hasData &&  (appConfig.news?.count)! > 0 {
                
                    let originalNews = strongSelf.config.news as? [LJConfigDataNewsModel]
                    
                    strongSelf.config = appConfig
                    
                    strongSelf.saveConfigData()
                    
                    strongSelf.checkNewsChanged(originalNews)
                    
                }
            }
            
        })
        
    }
    
    
    private func checkNewsChanged(_ originalNews : [LJConfigDataNewsModel]? ){
        
        var changed = true
        if let news = originalNews {
            
            if news.count == self.config.news.count {
                
                changed = false
                
                if let currentNews = self.config.news as? [LJConfigDataNewsModel] {
                    
                    for i in 0 ..< news.count {
                        
                        let onews = news[i]
                        let cnews = currentNews[i]
                        
                        if onews.name != cnews.name || onews.id != cnews.id {
                            changed = true
                            break
                        }
                    }
                }
            }
        }
        
        if changed {
            NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kAppNewsConfigUpdateNotification), object: nil)
        }
    }
    
    
    private func configPath() -> String {
        
        let docPath = TKFileUtil.docPath() as NSString
        
        return docPath.appendingPathComponent("app_config.dat")
        
    }
    
    
    private func saveConfigData() {
        
        if self.config != nil {
            
            let path = self.configPath()
            let json = self.config.toJSONString()
            do{
              try json?.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            }catch {
                
            }
        }
        
    }
    
    func nextRollRefreshTip(typeId:String) -> String {
        if config.refreshTipsRoll == nil {
            return ""
        }
        
        var index:Int = Int(arc4random_uniform(101));
        let tips:[String]? = config.refreshTipsRoll?[typeId] as? [String]
        if tips == nil || tips?.count == 0 {
            return ""
        }
        
        index = index % tips!.count;
        
        if (index == currentRollRefreshIndex) {
            index += 1
            if (index >= tips!.count) {
                index = 0
            }
        }
        
        currentRollRefreshIndex = index
        return tips![index]
    }
    
}
