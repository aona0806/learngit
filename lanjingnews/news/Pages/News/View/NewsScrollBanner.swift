//
//  NewsScrollBanner.swift
//  news
//
//  Created by chunhui on 16/1/5.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit
/// 新闻首页二级滚动banner
class NewsScrollBanner: UIView , UICollectionViewDataSource , UICollectionViewDelegate {

    var items = [String]()
    private var scrollView : UICollectionView?
    private var mobArray = [String]()
    var currentItem = String()
    
    static var itemWidth = CGFloat(80)
    
    private var selectedIndex = 0
    
    var titles = Array<LJConfigDataNewsModel>()
    
    var chooseItem:((_ index : Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initScrollView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initScrollView()
    }
    
    private func initScrollView(){
        
        if scrollView == nil {
            
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets.zero
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = CGFloat(0)
            layout.minimumInteritemSpacing = CGFloat(0)
            
            scrollView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
            scrollView?.delegate = self
            scrollView?.dataSource = self
            scrollView?.contentInset = UIEdgeInsets.zero
            scrollView?.showsHorizontalScrollIndicator = false
            scrollView?.scrollsToTop = false
            
            self.addSubview(scrollView!)
            
            //NewsScrollCollectionViewCell
            scrollView?.register(NewsScrollCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            
            scrollView?.backgroundColor = UIColor.rgba(232, green: 234, blue: 235, alpha: 1)
            
            self.addSubview(scrollView!)
            
        }
        
    }
    
    func updateWithItems(_ titles: [String]){
        
        items.removeAll()
        items.append(contentsOf: titles)
        mobArray = titles
        self.scrollView?.reloadData()
        self.scrollView?.layoutIfNeeded()        
    }
    
    func selectAtIndex(_ index : Int) {
        
        var item = index
        let model = titles[item]

        currentItem = model.id.stringValue
        let mobString = "NewsInfo_sub_" + currentItem + "_" + model.name
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            MobClick.event(mobString)
        }
        
        if index < 0 {
            item = 0
        }else if index >= items.count {
            item = items.count - 1
        }
        
        let indexPath = IndexPath(item: item, section: 0)
        self.scrollView?.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
        scrollItemToFit(indexPath)
    }

    
    private func scrollItemToFit(_ indexPath : IndexPath){
        
        var offsetx = CGFloat(0.0)
        
        for i in 0  ..< (indexPath as NSIndexPath).item  {
            offsetx += self.collectionView(scrollView!, layout: scrollView!.collectionViewLayout, sizeForItemAtIndexPath: IndexPath(item: i, section: 0)).width
        }
        let width = self.collectionView(scrollView!, layout: scrollView!.collectionViewLayout, sizeForItemAtIndexPath: IndexPath(item: (indexPath as NSIndexPath).item, section: 0)).width
        
        if offsetx < (scrollView?.contentOffset.x)! {
            
            scrollView?.scrollToItem(at: indexPath, at: .left, animated: true)
            
        }else if offsetx + width > scrollView!.contentOffset.x + scrollView!.width {
            
            scrollView?.scrollToItem(at: indexPath, at: .right, animated: true)
        }
        
        self.selectedIndex = (indexPath as NSIndexPath).row
        scrollView?.reloadData()
    }
    
    // MARK: - collection view delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)  as! NewsScrollCollectionViewCell
        
        cell.titleLabel.text = items[(indexPath as NSIndexPath).item]
        let isSelected = (indexPath as NSIndexPath).row == self.selectedIndex
        cell.updateView(isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.scrollItemToFit(indexPath)
        
        if let chooseBlock = chooseItem {
            chooseBlock((indexPath as NSIndexPath).item)
        }
    }
    
    
    // MARK : flow layout delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let title = items[(indexPath as NSIndexPath).item]
                
        return CGSize(width: NewsScrollCollectionViewCell.cellWidthForTitle(title), height: collectionView.bounds.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets.zero
    }

}
