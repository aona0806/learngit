//
//  NewsViewController.swift
//  news
//
//  Created by chunhui on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

/*
* 新闻
*/
class NewsViewController: LJBaseViewController , UICollectionViewDataSource,UICollectionViewDelegate {

    var verified : String? = nil
    private var visibleControllers = [NewsListViewController]()
    private var cacheControllers = [NewsListViewController]()
    private var collectionView : UICollectionView? = nil
    private var scrollBannerView : NewsScrollBanner? = nil
    private var lastNavibarBottom = GlobalConsts.NormalNavbarHeight
    private var lastShowTabbar = false
    
    static let bannerHeight = CGFloat(35)
    private  var bannerConfig : LJConfigDataModel {
        
        get{
            return ConfigManager.sharedInstance().config
        }
        
    }
    
    func getCurrentSelectedItem() -> String? {
        
        return self.scrollBannerView!.currentItem
    }
    
    // MARK: - Lifecycle    
    override func viewDidLoad() {
        self.customUserInfoItem = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.view.backgroundColor = UIColor.white
        self.initCaches()
        self.buildNavbar()
        initScrollBanner()
        initCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(forceRefreshNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kNewsRefreshNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newsConfigChangedNotification(_:)), name: NSNotification.Name(rawValue: GlobalConsts.kAppNewsConfigUpdateNotification), object: nil)
        
        self.view.setNeedsUpdateConstraints()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
        
        scrollBannerView?.snp.updateConstraints({ (make) -> Void in
            
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(NewsViewController.bannerHeight)
            let offset = self.navigationController!.navigationBar.bottom - CGFloat(64)
            make.top.equalTo(self.view).offset(offset)
        })
        
        if self.tabBarController!.tabBar.isHidden == self.lastShowTabbar || lastNavibarBottom != self.navigationController!.navigationBar.height {
            
            self.lastShowTabbar = !self.tabBarController!.tabBar.isHidden
            
            collectionView?.snp.updateConstraints({ (make) -> Void in
                
                var tabbarHeight = CGFloat(0.0)
                if lastShowTabbar {
                    tabbarHeight = self.tabBarController!.tabBar.height
                }
                make.bottom.equalTo(self.view).offset(-tabbarHeight)
                
            })
            DispatchQueue.main.async(execute: {
                self.collectionView?.reloadData()
            })
            
            lastNavibarBottom = self.navigationController!.navigationBar.height
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func reload(){
        
        for controller  in cacheControllers {
            controller.removeFromParentViewController()
        }
        cacheControllers.removeAll()
        for contrller in visibleControllers {
            contrller.removeFromParentViewController()
        }
        visibleControllers.removeAll()
        
        self.initCaches()
        self.collectionView?.reloadData()
        
        self.collectionView?.scrollToItem(at: IndexPath(item: 0 , section: 0), at: .left, animated: false)
        
        self.initScrollBanner()
        
    }
    
    // MARK: - private
    
    private func buildNavbar() {
        
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 145, height: 28))
        let titleImage = UIImage(named: "navgationbar_news_logo")
        titleImageView.image = titleImage
        self.navigationItem.titleView = titleImageView
    }
    
    private func initCollectionView() {
        
        if collectionView == nil {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = CGFloat(0)
            layout.minimumInteritemSpacing = CGFloat(0)
            layout.sectionInset = UIEdgeInsets.zero
            
            var frame = self.view.frame
            frame.size.height -= NewsViewController.bannerHeight
            frame.origin.y = NewsViewController.bannerHeight
            
            
            collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            collectionView?.autoresizingMask = .flexibleHeight
            collectionView?.contentInset = UIEdgeInsets.zero
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.showsVerticalScrollIndicator = false
            collectionView?.scrollsToTop = false
            
            self.view.addSubview(collectionView!)
            
            collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.isPagingEnabled = true
            
            collectionView?.backgroundColor = UIColor.white
            
            self.view.addSubview(collectionView!)
            
            self.lastShowTabbar = !self.tabBarController!.tabBar.isHidden
            
            collectionView?.snp.makeConstraints({ (make) -> Void in
                make.top.equalTo(scrollBannerView!.snp.bottom)
                var tabbarHeight = CGFloat(0.0)
                if lastShowTabbar {
                    tabbarHeight = self.tabBarController!.tabBar.height
                }
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view).offset(-tabbarHeight)
            })
            
        }
    }
    
    private func initScrollBanner(){
        
        if scrollBannerView == nil {
            
            scrollBannerView = NewsScrollBanner(frame: CGRect(x: 0,y: 0,width: self.view.width,height: NewsViewController.bannerHeight))
            scrollBannerView?.chooseItem = chooseBannerItem

            
            self.view.addSubview(scrollBannerView!)
        }
    
        var items = [String]()
        for newItem in self.bannerConfig.news as! [LJConfigDataNewsModel] {
            items.append(newItem.name)
        }

        scrollBannerView?.titles = self.bannerConfig.news as! Array<LJConfigDataNewsModel>
        scrollBannerView?.updateWithItems(items)
        scrollBannerView?.selectAtIndex(0)
    }
    
    private func chooseBannerItem(_ index : Int){
        
        let selIndexpaths = self.collectionView!.indexPathsForVisibleItems
        
        let model = self.bannerConfig.news[index] as? LJConfigDataNewsModel
        let titleString = model?.name ?? ""
        let idString = model?.id.stringValue ?? ""
        self.event(forName: "News_item_5_2_0", attr: ["title": titleString, "nid":idString])

        for indexpath in selIndexpaths {
            
            if (indexpath as NSIndexPath).item == index {
                
                let controller = self.viewControllerAtIndex(index)
                controller.reload(true)//重新加载
                
                return
            }
            
        }
        
        self.collectionView?.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
        
    }
    
    func handleWillDisappear(_ index : Int){
        
        for i in 0 ..< visibleControllers.count {
            let controller = visibleControllers[i]
            if controller.view.tag == index {
                
                visibleControllers.remove(at: i)
                
                cacheControllers.append(controller)
                cacheControllers.sort(by: { (controller1, controller2) -> Bool in
                    
                    return controller1.view.tag < controller2.view.tag
                    
                })
                controller.removeFromParentViewController()
                controller.view.removeFromSuperview()
                controller.clearForReuse()
                
                break
            }
        }
    }
    
    private func initCaches(){
        
        for i in 0  ..< min(3, self.bannerConfig.news.count)  {
            
            let typeModel = self.bannerConfig.news[i] as! LJConfigDataNewsModel
            let controller = NewsListViewController(catType: typeModel)
            controller.view.tag = -1
            controller.pushController = self.onPushController
            
            cacheControllers.append(controller)
            
        }
        
    }
    
    func viewControllerAtIndex(_ index : Int) -> NewsListViewController{
        
        var controller : NewsListViewController?
        var find = false
        
        for vcontroller in visibleControllers {
            if vcontroller.view.tag == index {
                //in visible controller list
                return vcontroller
            }
        }
        
        
        for  i in 0  ..< cacheControllers.count  {
            controller = cacheControllers[i]
                        
            if controller!.view.tag == index {
                cacheControllers.remove(at: i)
                find = true
                break
            }
        }
        
        let typeModel = self.bannerConfig.news[index] as! LJConfigDataNewsModel
        
        if !find {
            if cacheControllers.count > 0 {
                
                if cacheControllers.first!.view.tag < 0 || cacheControllers.last!.view.tag > index {
                    controller = cacheControllers.first
                    cacheControllers.removeFirst()
                }else{
                    controller = cacheControllers.last
                    cacheControllers.removeLast()
                }
            }else{
               
                controller = NewsListViewController(catType: typeModel)
                controller!.pushController = self.onPushController
            }
            
            controller?.view.tag = index
            
        }
        
        //to do add
        controller?.typeModel = self.bannerConfig.news[index] as! LJConfigDataNewsModel
        

        
        visibleControllers.append(controller!)
        self.addChildViewController(controller!)
        
        return controller!
    }
    
    func onPushController(_ viewController : UIViewController) -> (){
        
        viewController.hidesBottomBarWhenPushed = true
        // 4S 以及以下的不显示动画
        let screen = UIScreen.main.bounds
        let animated = (screen.size.width < 321 && screen.size.height < 490) ? false : true
        self.navigationController?.pushViewController(viewController, animated: animated)
        
    }

    
    // MARK: - Navigation
    // MARK: - collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return scrollBannerView!.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let controller = viewControllerAtIndex((indexPath as NSIndexPath).item)
        
        controller.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(controller.view)    
        
//        if Int((collectionView.contentOffset.x + collectionView.width/2) / collectionView.width) == indexPath.item {
            //只加载当前显示的
            controller.reload(false)
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        handleWillDisappear((indexPath as NSIndexPath).item)
        
        let item = collectionView.contentOffset.x / collectionView.width
        scrollBannerView?.selectAtIndex(Int(item))
        
    }
    
    // MARK : flow layout delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
                
        return collectionView.frame.size
        
//        if self.tabBarController!.tabBar.hidden {
//
//        }
//
//        return CGSizeMake(collectionView.width, collectionView.height - self.tabBarController!.tabBar.height)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }

    //refresh notification
    func forceRefreshNotification(_ ntofication : Notification){
        
        let indexes: [IndexPath]! = self.collectionView?.indexPathsForVisibleItems;
        if (indexes?.count)! > 0 {
            let indexPath = indexes![0];
            let viewController: NewsListViewController! = viewControllerAtIndex((indexPath as NSIndexPath).item)
            viewController.reload(true)
        }
    }
    
    func newsConfigChangedNotification(_ notification : Notification){
        
        self.reload()
        
    }
}
