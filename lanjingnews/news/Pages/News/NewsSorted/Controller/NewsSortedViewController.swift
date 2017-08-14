//
//  NewsSortedViewController.swift
//  news
//
//  Created by 奥那 on 2017/5/8.
//  Copyright © 2017年 lanjing. All rights reserved.
//

import UIKit

class NewsSortedViewController: LJBaseViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    private var collectionView : UICollectionView!
    private var tempMoveView : UIView?
    private var lastIndexPath : IndexPath!
    private var size : CGSize!
    private var confirmBut : UIButton!
    private var titleArray = NSMutableArray()
    private var idArray = NSMutableArray()
    private var newsArray = NSMutableArray()
    
    private  var config : LJConfigDataModel {
        
        get{
            return ConfigManager.sharedInstance().config
        }
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "排序"
        
        getData()
        setupNavi()
        setUpSubViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavi(){
        confirmBut = UIButton()
        confirmBut.frame = CGRect.init(x: 0, y: 0, width: 50, height: 40)
        confirmBut.setImage(UIImage.init(named: "news_confirm_normal"), for: .normal)
        confirmBut.setImage(UIImage.init(named: "news_confirm_selected"), for: .selected)
        confirmBut.addTarget(self, action: #selector(confirmSorted(_:)), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: confirmBut)
    }

    func setUpSubViews(){
        
        let view = NewsSortedView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 70))
        self.view.addSubview(view)
        
        let width = (UIScreen.main.bounds.width-36 - 3 * 13)/4.0
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize.init(width: width, height: 30)
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumInteritemSpacing = 13
        flowlayout.minimumLineSpacing = 26
        
        collectionView = UICollectionView(frame: CGRect.init(x: 18, y: view.bottom, width: self.view.width-36, height: self.view.height), collectionViewLayout: flowlayout)
        
        collectionView?.register(NewsSortedCell.self , forCellWithReuseIdentifier: "cellid")
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        
        let longGes = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:)))
        collectionView.addGestureRecognizer(longGes)
        
        self.view.addSubview(collectionView)
    }
    
    func longPressed(_ sender : UILongPressGestureRecognizer){
        
        let location = sender.location(in: self.collectionView)
        let indexPath = collectionView.indexPathForItem(at: location)

        switch sender.state {
        case .began:
            gestureBegan(sender,indexPath: indexPath)
            break
        case .changed:
            gestureChanged(sender,indexPath: indexPath)
            break
        case .ended:
            gestureEnded(sender,indexPath: indexPath)
            break
        default:
            break
        }
        
    }
    
    func gestureBegan(_ sender : UILongPressGestureRecognizer , indexPath : IndexPath?){
        
        if indexPath == nil || indexPath?.row == 0{
            return
        }

        for sortCell in collectionView.visibleCells {
            (sortCell as! NewsSortedCell).showAnimation = true
        }
        let cell = collectionView.cellForItem(at: indexPath!) as! NewsSortedCell
        tempMoveView = cell.snapshotView(afterScreenUpdates: false)
        tempMoveView?.center = cell.center
        
        lastIndexPath = indexPath
        let point = sender.location(ofTouch: 0, in: sender.view)
        size = CGSize.init(width: point.x - cell.x, height: point.y - cell.y)
        
        cell.startMove()
        self.collectionView.addSubview(tempMoveView!)

    }
    
    func gestureChanged(_ sender : UILongPressGestureRecognizer , indexPath : IndexPath?){
        
        if indexPath == nil || indexPath?.row == 0{
            return
        }

        let currentPoint = sender.location(ofTouch: 0, in: sender.view)
        tempMoveView?.x = currentPoint.x - size.width
        tempMoveView?.y = currentPoint.y - size.height
        
        if lastIndexPath != nil && indexPath?.row != 0 && indexPath?.row != lastIndexPath.row {
            collectionView.moveItem(at: lastIndexPath, to: indexPath!)
            let cell = collectionView.cellForItem(at: indexPath!) as! NewsSortedCell
            cell.startMove()
            updateData(lastIndexPath, to: indexPath!)
            
            lastIndexPath = indexPath
        }
    }
    
    func gestureEnded(_ sender : UILongPressGestureRecognizer , indexPath : IndexPath?){

        if indexPath != nil && indexPath?.row != 0{
            removeEnded(indexPath!)
        }
        
        if (lastIndexPath != nil && indexPath == nil) || indexPath?.row == 0{
            removeEnded(lastIndexPath)

        }
    }
    
    func updateData(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){

        self.titleArray.exchangeObject(at: sourceIndexPath.row, withObjectAt: destinationIndexPath.row)

        
        self.idArray.exchangeObject(at: sourceIndexPath.row, withObjectAt: destinationIndexPath.row)
        
        newsArray.exchangeObject(at: sourceIndexPath.row, withObjectAt: destinationIndexPath.row)
        
    }
    
    func removeEnded(_ indexPath : IndexPath){
        //停止抖动
        for sortCell in collectionView.visibleCells {
            (sortCell as! NewsSortedCell).showAnimation = false
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! NewsSortedCell
        //结束时禁止交互  防止出问题
        self.collectionView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.tempMoveView?.center = cell.center
        }, completion: { (finish) in
            self.tempMoveView?.removeFromSuperview()
            cell.stopMove()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    //MARK: TKRequestHandler
    func getData(){

        TKRequestHandler.sharedInstance().getNewsSortedListFinish {[weak self] (sessionDataTask, model, error) -> Void in
            
            guard let strongSelf = self else {
                return
            }
            
            let hud = MBProgressHUD.showAdded( to: strongSelf.view ,animated:true)
            if error == nil{
                let model = model as! LJNewsSortModel
                if model.data != nil && model.data?.count != 0{
                    strongSelf.config.news = model.data
                    strongSelf.newsArray = NSMutableArray.init(array:model.data!)
                    for newItem in model.data as! [LJConfigDataNewsModel] {
                        let idStr = NSString.init(format: "%@", newItem.id)
                        strongSelf.idArray.add(idStr.intValue)
                        strongSelf.titleArray.add(newItem.name)
                        
                    }
                    NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kNewsSortedNotification), object: strongSelf.config.news)
                    
                    strongSelf.collectionView.reloadData()
                }
            }else{
                hud.label.text = "获取失败"
            }
            hud.hide(animated: true, afterDelay: 1)

        }
    }
    
    func confirmSorted(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        let hud = MBProgressHUD.showAdded( to: self.view ,animated:true)

        TKRequestHandler.sharedInstance().syncNewsSorted(withContent:self.idArray, complated: {(task, error) -> Void in
 
            if error == nil{
                NotificationCenter.default.post(name: Notification.Name(rawValue: GlobalConsts.kNewsSortedNotification), object: self.newsArray)
                ConfigManager.sharedInstance().syncConfig()

                hud.label.text = "保存成功"
                ConfigManager.sharedInstance().syncConfig()
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                hud.label.text = "保存失败"
            }
            hud.hide(animated: true, afterDelay: 1)
        })
    }
    
    //MARK:UICollectionViewDelegate DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! NewsSortedCell
        cell.updateTitle(title: self.titleArray[indexPath.row] as! String)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        updateData(sourceIndexPath, to: destinationIndexPath)
    }

}
