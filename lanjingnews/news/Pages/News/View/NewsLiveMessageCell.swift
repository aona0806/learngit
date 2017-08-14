//
//  NewsLiveMessageCell.swift
//  news
//
//  Created by 奥那 on 2016/12/27.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class NewsLiveMessageCell: BaseTableViewCell {
    
    private var leftImageView : UIImageView!
    private var backView : UIView!
    private var titleLabel : UILabel!
    private var lineView : UIView!
    private var timer : Timer!
    private var count = 0;
    private var titles = NSMutableArray()
    var typeId : String!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rollModel: LJNewsListDataListModel? {
        didSet {
            if (rollModel?.rollList?.count)! > 0{
                update()  
            }
        }
    }
    
    func buildView() {
        
        self.selectionStyle = .none
        
        leftImageView = UIImageView()
        leftImageView.image = UIImage.init(named: "news_telegraph")
        contentView.addSubview(leftImageView)
        
        backView = UILabel()
        backView.backgroundColor = UIColor.clear
        backView.clipsToBounds = true
        contentView.addSubview(backView)
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 2
        backView.addSubview(titleLabel)
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.init(colorLiteralRed: 242/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1)
        contentView.addSubview(lineView)
        
        initConstraints()
    
    }
    
    func initConstraints(){
        leftImageView.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(15)
            make.top.equalTo(contentView.snp.top).offset(15)
            make.width.equalTo(52)
            make.height.equalTo(32)
        }
        
        backView.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(leftImageView.snp.right).offset(24)
            make.top.equalTo(contentView.snp.top).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.bottom.equalTo(50).offset(-10)
        }
        
        titleLabel.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(backView.snp.left)
            make.top.equalTo(backView.snp.top)
            make.right.equalTo(backView.snp.right)
            make.height.equalTo(backView.snp.height)
        }
        
        lineView.snp.makeConstraints {(make) -> Void in
            make.left.equalTo(contentView.snp.left).offset(15)
            make.bottom.equalTo(contentView.snp.bottom).offset(-1)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.height.equalTo(1)
        }
    }
    
    func displayNews(){

        UIView.animate(withDuration: 0.1, animations: {
            self.titleLabel.frame.origin.y = -self.titleLabel.frame.height
        }, completion: { (finish) in
            
            self.titleLabel.frame.origin.y = self.titleLabel.frame.height
            UIView.animate(withDuration: 0.1, animations: {
                self.titleLabel.frame.origin.y = 0
                self.count += 1
                let max = self.titles.count > 5 ? 5 : self.titles.count
                if self.count > max - 1 {
                    self.count = 0
                }
                self.getTitleColor(self.count)
                self.titleLabel.text = self.titles[self.count] as? String
            })
            
        })
   
    }
    
    func update(){

        titles.removeAllObjects()
        if self.timer != nil{
            self.timer?.invalidate()
            self.timer = nil
        }
        
        for roll in (rollModel?.rollList)! {
            let title = (roll as! LJNewsListDataListRollListModel).content! as String
            titles.add(title)
        }
        count = 0
         self.getTitleColor(0)
        self.titleLabel.text = self.titles[0] as? String
        if self.titles.count > 1 && self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(NewsLiveMessageCell.displayNews), userInfo: nil, repeats: true)
        }
        
    }
    
    func getTitleColor(_ count : NSInteger){
        let rollList = (rollModel?.rollList)!
        let roll = rollList[count] as! LJNewsListDataListRollListModel

        if roll.marked != nil && roll.marked == "1" {
            titleLabel.textColor = UIColor.init(red: 225/150.0, green: 71/255.0, blue: 60/255.0, alpha: 1)
        }else{
            titleLabel.textColor = UIColor.black

        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let rollList = NSArray.init(array: (rollModel?.rollList)!)
        if count < rollList.count{
            let rollModel = rollList.object(at: count) as! LJNewsListDataListRollListModel
            
            if (rollModel.jump?.length())! > 0{
                PushManager.sharedInstance.handleOpenUrl(rollModel.jump!)

                MobClick.event("Roll_Click", attributes: ["typeId":typeId])
            }
        }
        
    }
    
    deinit{
       
        self.timer?.invalidate()
        
    }
}
