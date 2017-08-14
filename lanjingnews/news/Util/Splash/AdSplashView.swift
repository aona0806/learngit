//
//  AdSplashView.swift
//  news
//
//  Created by chunhui on 16/3/15.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

/// 广告闪屏
class AdSplashView: UIView , UICollectionViewDataSource , UICollectionViewDelegate{

    private var bgCollectionView : UICollectionView? = nil
    private var skipButton = UIButton(type: .custom)
    private var adModel : LJAdModel? = nil
    private var logoImageView = UIImageView()
//    private var introView : ADIntroView? = nil
    private var placeholder : UIImageView? = nil
    private var timer : Timer? = nil
    
    static func adView(_ model: LJAdModel) -> AdSplashView {
        
        let view = AdSplashView(frame: UIScreen.main.bounds)
        view.adModel = model
        return view
        
    }
    
    
    func show(_ itemDuration : TimeInterval = 4){
        
        let window = AppDelegate.appDelegate().window
//        window?.rootViewController?.view.addSubview(self)
        DispatchQueue.main.async { 
            window?.addSubview(self)
        }
        
        
        
        guard let data =  self.adModel?.data  else {
            return
        }
        if data.count > 0 {
            self.startScroll(itemDuration)
        }        
    }
    
    func dismiss(_ animated : Bool = true , afterDely : Double = 0){
                
        if afterDely == 0 {
            
            self.timer?.invalidate()
            self.timer = nil
            
            if animated {
                UIView.animate(withDuration: 0.8, animations: {[weak self] () -> Void in
                    self?.alpha = 0
                    }) {[weak self] (finished) -> Void in
                        self?.removeFromSuperview()
                }
            }else{
                self.removeFromSuperview()
            }
            
        }else {
            
            let ms = (UInt64)(afterDely * 1000.0)
                        
            let when = DispatchTime.now() + Double((Int64)(ms * NSEC_PER_SEC / 1000)) / Double(NSEC_PER_SEC)
//            DispatchQueue.main.after(when: when, execute: {[weak self] () -> Void in
//                self?.dismiss(animated)
//            })
            DispatchQueue.main.asyncAfter(deadline: when, execute: { [weak self] () -> Void in
                self?.dismiss(animated)
            })
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = frame.size
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0
        
        bgCollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowlayout)
        
        bgCollectionView?.register(UICollectionViewCell.self , forCellWithReuseIdentifier: "cellid")
        bgCollectionView?.isPagingEnabled = true
        
        bgCollectionView?.delegate = self
        bgCollectionView?.dataSource = self
        bgCollectionView?.backgroundColor = UIColor.white
        
        self.addSubview(bgCollectionView!)
        
        skipButton.frame = CGRect(x: self.width - 99, y: 15 + 20, width: 84, height: 33)
        let bgImage = UIImage(named: "splash_skip")
        skipButton.setBackgroundImage(bgImage, for: UIControlState())
        skipButton.addTarget(self, action: #selector(AdSplashView.skipAction(_:)), for: .touchUpInside)
        self.addSubview(skipButton)
        
        self.backgroundColor = UIColor.white
        
        
        let image = UIImage(named: "splash_logo")
        self.logoImageView.image = image
        self.logoImageView.frame = CGRect(x: 0, y: self.height - 64, width: self.width, height: 64)
        
        self.addSubview(logoImageView)
        
        
        let launch = TKAppInfo.launchImage()
        placeholder = UIImageView(image: launch)
        placeholder?.frame = self.bounds
        self.addSubview(placeholder!)
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] () -> Void in
            self?.placeholder?.alpha = 0
            }) {[weak self] (finish) -> Void in
                self?.placeholder?.removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        
        self.timer?.invalidate()
        
    }
    
    
    func startScroll(_ duration : TimeInterval) {
        
        self.timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(AdSplashView.doScroll), userInfo: nil, repeats: true)
    }
    
    func doScroll(){
    
        guard let _ = self.bgCollectionView else {
            return
        }
        var  index = (Int)(self.bgCollectionView!.contentOffset.x / self.width)
        if(index < self.adModel!.data.count - 1){
            index += 1
            
            self.bgCollectionView?.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
        }else{
            self.timer?.invalidate()
            self.dismiss(true , afterDely: 4)
        }
    }
    
    func skipAction(_ sender : UIButton){
        
        self.dismiss()
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let model = adModel?.data else{
            return 0
        }
        return model.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath)
        var bgImageView = cell.contentView.viewWithTag(1111) as? UIImageView
        if bgImageView == nil {
            bgImageView = UIImageView(frame: self.bounds)
            bgImageView?.tag = 1111;
            cell.contentView.addSubview(bgImageView!)
        }
        bgImageView?.contentMode = .scaleAspectFill
        bgImageView?.clipsToBounds = true
        
        let model = adModel!.data[(indexPath as NSIndexPath).item]

        let url = Urlhelper.tryEncode((model as AnyObject).imgUrl)
        bgImageView?.sd_setImage(with: url)
//        introView?.updateWithTitle(model.title, content: model.remark)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        let model = adModel!.data[(indexPath as NSIndexPath).item]
        
        let jmp = String((model as AnyObject).goUrl)//对于oc转过来的对象，当其为nil时,不能使用？ 这种方式
        
        if  (jmp?.length())! > 0  && jmp != "nil" {
            
            PushManager.sharedInstance.handleOpenUrl(jmp!)
            //能跳转时点击才消失
            self.dismiss(false)
        }
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}

class ADIntroView : UIView {
    
    private var titleLabel = UILabel()
    private var contentLabel = UILabel()
    private var indicatorImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        titleLabel.textColor = UIColor.white
        
        contentLabel.font = UIFont.systemFont(ofSize: 20)
        contentLabel.textColor = UIColor.white
        
        indicatorImageView.image = UIImage(named: "splash_indicator")

        indicatorImageView.frame = CGRect(x: self.width - 24 - 30, y: self.height/2 - 24, width: 24, height: 45)

        var labelFrame = CGRect(x: 35, y: 26, width: indicatorImageView.left - 35 - 5, height: 30)
        titleLabel.frame = labelFrame
        
        labelFrame.origin.y += labelFrame.height + 12
        contentLabel.frame = labelFrame
        
        self.addSubview(titleLabel)
        self.addSubview(contentLabel)
        self.addSubview(indicatorImageView)
        
    }

    func updateWithTitle(_ title : String? , content : String?){
        
        titleLabel.text = title
        contentLabel.text = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
