//
//  NoResultTipView.swift
//  news
//
//  Created by chunhui on 16/1/11.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NoResultTipView: UIView {

    private var refreshButton : UIButton?
    private var tipLabel : UILabel?
    
    var refreshClosure:((_ view:NoResultTipView)->Void)?
    
    //noresult_refresh
    
    private func initItems(){
        
        if tipLabel == nil {
            
            tipLabel = UILabel()
            
            tipLabel?.textColor = UIColor.rgb(0x999999)
            tipLabel?.backgroundColor = UIColor.clear
            tipLabel?.textAlignment = .center
            
            self.addSubview(tipLabel!)
            
            tipLabel?.snp.makeConstraints({ (make) -> Void in
                make.center.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
            })
        }
        
        if refreshButton == nil {
            
            refreshButton = UIButton(type: .custom)
            let image = UIImage(named: "noresult_refresh")
            refreshButton?.setBackgroundImage(image, for: UIControlState())
            
            weak var weakSelf = self
            refreshButton?.bk_addEventHandler({ (AnyObject) -> Void in
                
                if weakSelf?.refreshClosure != nil {
                    weakSelf?.refreshClosure?(weakSelf!)
                }
                
                }, for: .touchUpInside)
            
            self.addSubview(refreshButton!)
            
            refreshButton!.snp.makeConstraints({ (make) -> Void in
                
                make.bottom.equalTo(tipLabel!.snp.top).offset(-10)
                make.centerX.equalTo(self)
                
            })
        }
       
        self.backgroundColor = UIColor.lightGray
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initItems()
    }
   
    convenience init( title : String){
        
        let frame = UIScreen.main.bounds
        self.init(frame: frame)
        self.tipLabel?.text = title
        
    }
    
    class func noresultView(_ title: String) -> NoResultTipView {
    
        let view = NoResultTipView(frame:UIScreen.main.bounds)
        view.tipLabel?.text = title
        
        return view
        
    }
    
    class func netErrorView() -> NoResultTipView {
        
        return NoResultTipView(title: "网络连接失败，点击重新加载")
        
    }
    
    class func noresultView() -> NoResultTipView {
        
        return NoResultTipView(title: "没有结果")
        
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
