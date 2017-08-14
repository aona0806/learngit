//
//  NewsListViewController.swift
//  news
//
//  Created by chunhui on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

@objc public enum LJTemplateType : Int {
    
    case newsNone
    case newsSingle
    case newsMultiple
    case activity
    case topics
    case conference
    case banner
    case ad
    case softAD
    case multipleAd
    case scrollRoll
    
    func translateString() -> String{
        switch self {
        case .newsNone:
            return "news_none"
        case .newsSingle:
            return "news_single"
        case .newsMultiple:
            return "news_multiple"
        case .activity:
            return "activity"
        case .topics:
            return "topic"
        case .conference:
            return "meeting"
        case .banner:
            return "banner"
        case .ad:
            return "inline_ad"
        case .softAD:
            return "single_ad"
        case .multipleAd:
            return "multiple_ad"
        case .scrollRoll:
            return "scroll_roll"
        }
    }
}

class NewsListViewController: LJBaseTableViewController, TKSwitchSlidePageItemViewControllerProtocol {
    var dataArray: Array<LJNewsListDataListModel>! = []
    
    private var photoBrowser: FSPhotoBrowserHelper! = FSPhotoBrowserHelper()

    var tableHeadView: MJRefreshNormalHeader!
    var tableFootView: MJRefreshBackNormalFooter!
    
    weak var requestTask : URLSessionDataTask?
    
    private var cellHeightCache = [String : CGFloat]()
    var isCompleteDownload: Bool! = true
    
    var typeModel: LJConfigDataNewsModel! {
        willSet{
            
            if self.typeModel.id != newValue.id {
//               self.saveCache(self.typeModel)
                self.dataArray.removeAll()
                self.tableView.reloadData()
                self.tryLoadCache(newValue)
                
            }
        }
    }

    //convenience
    
    // MARK: - Lifecycle
    init(catType: LJConfigDataNewsModel) {
        super.init(style: .plain)
        
        self.typeModel = catType
        self.tableView.dataSource = self
        self.tableView.delegate  = self
        self.tableView.separatorStyle = .none
        
        weak var weakSelf = self
        tableHeadView = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            weakSelf!.update(typeModel: weakSelf!.typeModel, refreshType: .refresh)
        })
        
        tableFootView = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            weakSelf!.update(typeModel: weakSelf!.typeModel, refreshType: .loadMore)
        })
        
        self.tableView.header = tableHeadView
        self.tableView.footer = tableFootView
        
        self.tryLoadCache(typeModel)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    var pushController : ((_ viewController : UIViewController) -> ())?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false

        reload()
    }
    
    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        print(typeModel.id)
//        if self.view.height < 480 {
            self.tableView.reloadData()
//        }
        
        if typeModel.id != 1{
            checkGuideView()
        }
    }
    
    func checkGuideView(){
        let isLoad:Bool = UserDefaults.standard.bool(forKey: GlobalConsts.KUserDefaultsNewsListGuideView)
                if !isLoad {
        UserDefaults.standard.set(true, forKey: GlobalConsts.KUserDefaultsNewsListGuideView)
        UserDefaults.standard.synchronize()
        let view = NewsGuideView.init(frame: UIScreen.main.bounds)
        let window = UIApplication.shared.keyWindow
        window?.addSubview(view)
                }
    }
    
    func removeUnRecognizeType(_ array: [LJNewsListDataListModel]) -> [LJNewsListDataListModel]! {
        
        var rtnArray = [LJNewsListDataListModel]()

        let stringArray = ["news_none", "news_single", "news_multiple", "activity", "topic", "meeting", "banner", "inline_ad", "single_ad","multiple_ad","scroll_roll"]
        
        for model in array {
            let templateTypeString = model.templateType ?? ""
            
            if stringArray.contains(templateTypeString) {
                rtnArray.append(model)
            }
        }
        return rtnArray
    }
    
    /*
     * 广告回调
     */
    func checkAdCallback(_ array: [LJNewsListDataListModel]){
        
        var urls = [String]()
        for model in array {
            if let show = model.tshow {
                urls.append(show)
            }
            
            if let view = model.tview {
                urls.append(view)
            }
        }
        
        for url in urls {
            if url.length() > 0 {
                let _ = TKNetworkManager.sharedInstance()?.get(url, parameters: nil, success: nil, failure: nil)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     * 让tableview显示刷新
     */
    func trigerRefresh(){
        self.tableView.header.beginRefreshing()
    }
    
    func clearForReuse(){
        
        self.saveCache(self.typeModel)
        requestTask?.cancel()
    }
    
    func update(typeModel : LJConfigDataNewsModel, refreshType: TKDataFreshType) {
        
        if !isCompleteDownload {
            return
        }
        
        self.typeModel = typeModel
        //        let vc = self.viewController as? LJBaseTableViewController
        //        let hud = vc?.showLoadingGif()
        
        var lastTime: String = "0"
        if refreshType == .loadMore && (self.dataArray?.count ?? 0) > 0 {
            for  m in Array(self.dataArray!.reversed()){
                if let time = m.lastTime {
                    //当有广告时没有lasttime 需要虑掉
                    lastTime = time
                    break
                }
            }            
        }
        let modelId = typeModel.id.intValue
        TKRequestHandler.sharedInstance().getNewsListFeed(modelId, lastTime: lastTime, rn: 20, refreshType: refreshType) { [weak self] (sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            //            hud?.hideAnimated(true)
            
            strongSelf.isCompleteDownload = true
            strongSelf.stopRefresh(strongSelf.tableView)
            
//            strongSelf.tableHeadView.endRefreshing()
//            strongSelf.tableFootView.endRefreshing()
            
            if sessionDataTask.state == .canceling {
                //user cancelled
                return
            }

            if error == nil {
    
                if model?.dErrno == "0" {
                    var newValueArray = model?.data?.list as? Array<LJNewsListDataListModel> ?? []
                    
                    newValueArray = strongSelf.removeUnRecognizeType(newValueArray) ?? []
                    strongSelf.checkAdCallback(newValueArray)
                    
                    for item in newValueArray {
                        let templateTypeString = item.templateType ?? ""
                        if templateTypeString == LJTemplateType.ad.translateString() {
                            strongSelf.event(forName: "AD_inline_show", attr: nil)
                        } else if templateTypeString == LJTemplateType.softAD.translateString() {
                            strongSelf.event(forName: "AD_feedflow_show", attr: nil)
                        }else if templateTypeString == LJTemplateType.multipleAd.translateString() {
                            strongSelf.event(forName: "AD_Multiple_show", attr: nil)
                        }
                    }
                    
                    if refreshType == .refresh {
                        strongSelf.cellHeightCache.removeAll()
                        strongSelf.dataArray = newValueArray
                        strongSelf.tableView.reloadData()
                        
                    } else if refreshType == .loadMore {
                        let row = strongSelf.dataArray.count
                        let indexPath = IndexPath(row: row, section: 0)
                        strongSelf.dataArray = self!.dataArray + newValueArray
                        strongSelf.tableView.reloadData()
                        if row < strongSelf.tableView.numberOfRows(inSection: 0) {
                            strongSelf.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                        }
                    }
                    
                } else if model?.dErrno == "20016" {
                    
                } else {
                    let toAddView: UIView! = strongSelf.tableView.superview
                    let hud  = MBProgressHUD.showAdded(to: toAddView, animated:true)
                    hud.mode = .text
                    let msg = model?.msg ?? GlobalConsts.NetRequestNoResult
                    hud.detailsLabel.text = msg
                    hud.detailsLabel.font = GlobalConsts.ToastFont
                    hud.hide(animated: true, afterDelay: LJUtil.toastInterval(msg))
                }
            } else {
                
                if let toAddView = strongSelf.tableView.superview {
                    let hud  = MBProgressHUD.showAdded(to: toAddView, animated:true)
                    hud.mode = .text
                    let msg = GlobalConsts.NetRequestNoResult
                    hud.detailsLabel.text = msg
                    hud.detailsLabel.font = GlobalConsts.ToastFont
                    hud.hide(animated: true, afterDelay: LJUtil.toastInterval(msg))
                }
            }
            
        }
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model: LJNewsListDataListModel! = self.dataArray[(indexPath as NSIndexPath).row]
        let templateType = model.templateType ?? ""
        var key = ""
        
        if let nid = model.nid {
            key = "\(templateType)_\(nid)"
            if let cellheight = cellHeightCache[key] {
                return cellheight
            }
        }
        var height: CGFloat! = 0
        
        switch templateType {
        case LJTemplateType.newsNone.translateString():
            height = NewsNoneTableViewCell.heightForInfo(model)
        case LJTemplateType.newsSingle.translateString():
            height = NewsSingleTableViewCell.heightForInfo(model)
        case LJTemplateType.newsMultiple.translateString():
            height = NewsMultipleTableViewCell.heightForInfo(model)
        case LJTemplateType.topics.translateString():
            height = LJTopicTableViewCell.heightForCell(model)
        case LJTemplateType.activity.translateString():
            height = LJNewsActivityTableViewCell.heightForCell(model)
        case LJTemplateType.conference.translateString():
            height = LJNewsActivityTableViewCell.heightForCell(model)
        case LJTemplateType.banner.translateString():
            height = LJBannerTableViewCell.fitHeight()
        case LJTemplateType.ad.translateString():
            height = NewsAdTableViewCell.heightForInfo(model)
        case LJTemplateType.softAD.translateString():
            height = NewsSoftArticleAdTableViewCell.heightForInfo(model)
        case LJTemplateType.multipleAd.translateString():
            height = NewsMutipleAdTableViewCell.heightForInfo(model)
        case LJTemplateType.scrollRoll.translateString():
            height = (model.rollList?.count)! > 0 ? 65 : 0
        default:
            
            break
        }
        
        if !key.isEmpty {
            if height > 0 {
                cellHeightCache[key] = height
            }
        }

        return height
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: LJNewsListDataListModel! = self.dataArray[(indexPath as NSIndexPath).row]
        
        let templateTypeString = model.templateType ?? ""
        if templateTypeString == LJTemplateType.ad.translateString() {
            self.event(forName: "AD_inline_click", attr: nil)
        } else if templateTypeString == LJTemplateType.softAD.translateString() {
            self.event(forName: "AD_feedflow_click", attr: nil)
        } else if templateTypeString == LJTemplateType.banner.translateString() {
            self.event(forName: "AD_banner_click", attr: nil)
        } else if (templateTypeString == LJTemplateType.newsNone.translateString() || templateTypeString == LJTemplateType.newsSingle.translateString() || templateTypeString == LJTemplateType.newsMultiple.translateString()) {
            self.event(forName: "News_List_ToDetail", attr: nil)
        }

        
        let formSubId = self.typeModel.id?.stringValue
        let viewController = PushManager.sharedInstance.getNewsDetailViewController(model.jump, fromSubId: formSubId)

        if viewController != nil {
            self.pushController?(viewController!)
        }
    }
//    func tableView(tableView: UITableView, didSelectRowWithInfo info: LJNewsListDataListModel) {
//        
//        let formSubId = self.typeModel.id?.stringValue
//        let viewController = PushManager.sharedInstance.getNewsDetailViewController(info.jump, fromSubId: formSubId)
//        if viewController != nil {
//            self.pushController?(viewController: viewController!)
//        }
//    }
    
    // MARK: - UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = dataArray.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let model: LJNewsListDataListModel! = dataArray[(indexPath as NSIndexPath).row]
        let templateTypeString = model.templateType ?? ""
        switch templateTypeString {
        case LJTemplateType.newsNone.translateString() :
            
            var cell = tableView.dequeueReusableCell(withIdentifier: NewsNoneTableViewCell.Identify) as? NewsNoneTableViewCell
            if cell == nil {
                cell = NewsNoneTableViewCell(style: .default, reuseIdentifier: NewsNoneTableViewCell.Identify)
            }
            return cell!
        case LJTemplateType.newsSingle.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: NewsSingleTableViewCell.Identify) as? NewsSingleTableViewCell
            if cell == nil {
                cell = NewsSingleTableViewCell(style: .default, reuseIdentifier: NewsSingleTableViewCell.Identify)
            }
            
            return cell!
        case LJTemplateType.newsMultiple.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: NewsMultipleTableViewCell.Identify) as? NewsMultipleTableViewCell
            if cell == nil {
                cell = NewsMultipleTableViewCell(style: .default, reuseIdentifier: NewsMultipleTableViewCell.Identify)
            }
            
            return cell!
        case LJTemplateType.topics.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: LJTopicTableViewCell.Identify) as? LJTopicTableViewCell
            if cell == nil {
                cell = LJTopicTableViewCell(style: .default, reuseIdentifier: LJTopicTableViewCell.Identify)
            }
            return cell!
        case LJTemplateType.activity.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: LJNewsActivityTableViewCell.Identify) as? LJNewsActivityTableViewCell
            if cell == nil {
                cell = LJNewsActivityTableViewCell(style: .default, reuseIdentifier: LJNewsActivityTableViewCell.Identify)
            }
            cell!.templateType = LJTemplateType.activity
            return cell!
        case LJTemplateType.conference.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: LJNewsActivityTableViewCell.Identify) as? LJNewsActivityTableViewCell
            if cell == nil {
                cell = LJNewsActivityTableViewCell(style: .default, reuseIdentifier: LJNewsActivityTableViewCell.Identify)
            }
            cell!.templateType = LJTemplateType.conference
            return cell!
        case LJTemplateType.ad.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: NewsAdTableViewCell.Identify) as? NewsAdTableViewCell
            if cell == nil {
                cell = NewsAdTableViewCell(style: .default, reuseIdentifier: NewsAdTableViewCell.Identify)
            }
            cell?.info = model
            return cell!
        case LJTemplateType.banner.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: LJBannerTableViewCell.Identify) as? LJBannerTableViewCell
            if cell == nil {
                cell = LJBannerTableViewCell(style: .default, reuseIdentifier: LJBannerTableViewCell.Identify)
            }
            cell?.updatBanners(model)
            return cell!
        case LJTemplateType.softAD.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: NewsSoftArticleAdTableViewCell.Identify) as? NewsSoftArticleAdTableViewCell
            if cell == nil {
                cell = NewsSoftArticleAdTableViewCell(style: .default, reuseIdentifier: NewsSoftArticleAdTableViewCell.Identify)
            }
            return cell!
        case LJTemplateType.multipleAd.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: NewsMutipleAdTableViewCell.Identify) as? NewsMutipleAdTableViewCell
            if cell == nil {
                cell = NewsMutipleAdTableViewCell(style:.default , reuseIdentifier:NewsMutipleAdTableViewCell.Identify)
            }
            cell?.info = model
            return cell!
        case LJTemplateType.scrollRoll.translateString():
            var cell = tableView.dequeueReusableCell(withIdentifier: NewsLiveMessageCell.Identify) as? NewsLiveMessageCell
            if cell == nil {
                cell = NewsLiveMessageCell(style: .default, reuseIdentifier: NewsLiveMessageCell.Identify)
            }
            cell?.rollModel = model
            cell?.typeId = String.init(describing: typeModel.id)
            return cell!
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let model: LJNewsListDataListModel! = dataArray[(indexPath as NSIndexPath).row]
        
        let sel = NSSelectorFromString("setInfo:")//#selector(setInfo(_:))//Selector("setInfo:")
        if cell.responds(to: sel) {
            cell.perform(sel, with: model)
        }
    }
    
    
    private func imageTap(_ info: LJNewsListDataListModel? , imgs: [UIImageView]!, currentIndex: Int){
        
        
        if info != nil {
            
            let liftImageView : UIImageView! = imgs[currentIndex]
            
            photoBrowser.currentIndex = Int32(currentIndex)
            photoBrowser.liftImageView = liftImageView
            photoBrowser.placeHolderImages = imgs
            
            photoBrowser.images = info!.imgs
            
            photoBrowser.show()
        }
        
        
    }
    
    
    
    
    private func tryLoadCache(_ typeModel : LJConfigDataNewsModel){
        
        
        let cache = TMCache.shared()
        
        let typeKey = self.catCacheKey(typeModel)
        
        cache?.object(forKey: typeKey , block: { (cache, key, models) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if  let dataModels = models as? [LJNewsListDataListModel] {
                    
                    self.dataArray.append(contentsOf: dataModels)
                    if let tView = self.tableView {
                        tView.reloadData()
                    }
                }
            })
        })
        
        
    }
    
    private func saveCache(_ typeModel : LJConfigDataNewsModel){
        
        if self.dataArray.count > 0 {
            
            let cache = TMCache.shared()
            
            let typeKey = self.catCacheKey(typeModel)
            
            var models = [LJNewsListDataListModel]()
            models += self.dataArray
            
            cache?.setObject(models as NSCoding!, forKey: typeKey, block: { (cache, key, object) -> Void in
                
            })
        }
    }
    
    private func catCacheKey(_ typeModel : LJConfigDataNewsModel) -> String {
        
        return "news_cat_\(typeModel.name)"
    }
    
    // MARK: - private
    
    func reload(_ showRefresh : Bool = false){
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            if showRefresh {
                self.trigerRefresh()
                self.tableView.scrollRectToVisible(CGRect.zero, animated: true)
            }else{
                self.update(typeModel: self.typeModel, refreshType: .refresh)
            }
        })
    }
    
    // MARK: - TKSwitchSlidePageItemViewControllerProtocol
    
    func pageWillPurge() {
        
    }
    
    func pageWillReuse() {
        
    }
    
    func pageWillShow() {
        if self.dataArray.count == 0 {
            if requestTask == nil {
                self.reload(false)
            }
        }else{
            self.tableView.reloadData()
        }
        
        
    }
    
    func reuseable() -> Bool {
        return true
    }

}
