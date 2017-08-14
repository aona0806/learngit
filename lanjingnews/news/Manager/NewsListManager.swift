//
//  NewsListManager.swift
//  news
//
//  Created by 陈龙 on 16/1/8.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#if false
import UIKit

/// 新闻列表数据持久化

class NewsListManager: NSObject {

    static let sharedInstance : NewsListManager =  NewsListManager()
    
    private var mainList: Array<LJNewsListDataListModel>! = []
    private var mediaFiguresList: Array<LJNewsListDataListModel>! = []
    private var mediaNewsList: Array<LJNewsListDataListModel>! = []
    private var reportList: Array<LJNewsListDataListModel>! = []
    private var disseminationList: Array<LJNewsListDataListModel>! = []
    
    /**
     cache存储
     
     - parameter type: <#type description#>
     - parameter list: <#list description#>
     */
    func archiveCacheNewsList(type: LJCatType, list: Array<LJNewsListDataListModel>!) {
        
        switch type {
        case .Main:
            self.mainList = list
            break
        case .MediaFigures:
            self.mediaFiguresList = list
            break
        case .MediaNews:
            self.mediaNewsList = list
            break
        case .Report:
            self.reportList = list
            break
        case .Dissemination:
            self.disseminationList = list
            break
        }
    }
    
    /**
     cache读取
     
     - parameter type: <#type description#>
     
     - returns: <#return value description#>
     */
    func unarchiveCacheNewsList(type: LJCatType) -> Array<LJNewsListDataListModel>{
        
        var list: Array<LJNewsListDataListModel>! = []
        switch type {
        case .Main:
            list = self.mainList
            break
        case .MediaFigures:
            list = self.mediaFiguresList
            break
        case .MediaNews:
            list = self.mediaNewsList
            break
        case .Report:
            list = self.reportList
            break
        case .Dissemination:
            list = self.disseminationList
            break
        }
        return list
    }
    
    /**
     文件存储
     
     - parameter type: <#type description#>
     - parameter list: <#list description#>
     */
    func archiveFileNewsList(type: LJCatType, list: Array<LJNewsListDataListModel>) {
        
        let filePath = TKFileUtil.docPath() + type.filePath()
        NSKeyedArchiver.archiveRootObject(list, toFile: filePath)
    }
    
    /**
     文件读取
     
     - parameter type: <#type description#>
     
     - returns: <#return value description#>
     */
    func unarchiveFileNewsList(type: LJCatType) -> Array<LJNewsListDataListModel> {
        
        let filePath = TKFileUtil.docPath() + type.filePath()
        let model: Array<LJNewsListDataListModel>! = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? Array<LJNewsListDataListModel> ?? []
        return model
    }
}

#endif
