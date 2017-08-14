//
//  HelpPageView.swift
//  news
//
//  Created by wxc on 16/1/19.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

let helpPageCount = 3
class HelpPageView: UIView {
    
    var helpPageImageViewFirst:UIImageView! //头部按钮
    var helpPageImageViewSecond:UIImageView! //中间部分
    var helpPageImageViewThird:UIImageView!  //底部
    var currentPage = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupAllSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupAllSubViews(){
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        helpPageImageViewFirst = UIImageView.init(image: UIImage.init(named: "helppage_header"))
        helpPageImageViewFirst.isUserInteractionEnabled = true
        helpPageImageViewFirst.frame = CGRect(x: 0, y: 25, width: 30, height: 30)

        var position:CGFloat = GlobalConsts.screenWidth - 20
        
        //6s plus 与6 plus 位置不同
        if UIDevice.current.platform().hasPrefix("iPhone8") {
            position = GlobalConsts.screenWidth * 0.95
        }
    
        if GlobalConsts.screenHeight == 480 {
            position = GlobalConsts.screenWidth - 16
        }else if GlobalConsts.screenHeight == 568 {
            position = GlobalConsts.screenWidth - 22
        }else if GlobalConsts.screenHeight == 667 {
            position = GlobalConsts.screenWidth - 16
        }
        
        helpPageImageViewFirst.right = position
        
        helpPageImageViewSecond = UIImageView.init(image: UIImage.init(named: "helppage_message_first"))
        helpPageImageViewSecond.isUserInteractionEnabled = true
        helpPageImageViewSecond.contentMode = .scaleToFill
        
        helpPageImageViewThird = UIImageView.init(image: UIImage.init(named: "helppage_bottom"))
        helpPageImageViewThird.isUserInteractionEnabled = true
        helpPageImageViewThird.frame = CGRect(x: 0, y: GlobalConsts.screenHeight - 49, width: GlobalConsts.screenWidth, height: 49)
        
        let gapGesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(HelpPageView.gapGestureAction(_:)))
        self.addGestureRecognizer(gapGesture)
        
        self.addSubview(helpPageImageViewSecond)
        self.addSubview(helpPageImageViewFirst)
        self.addSubview(helpPageImageViewThird)
        
        helpPageImageViewSecond.snp.remakeConstraints { (make) -> Void in
            make.top.equalTo(self.snp.top).offset(64)
            make.bottom.equalTo(self.snp.bottom).offset(-64)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.helpPageImageViewFirst.snp.centerX)
        }
        
    }
    
    func gapGestureAction(_ sender:UITapGestureRecognizer){
        sender.isEnabled = false
        if currentPage < helpPageCount - 1 {
            //点击换张图片
            currentPage += 1
            weak var weakself = self
            if currentPage == 1{
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    weakself!.helpPageImageViewFirst.alpha = 0
                    weakself!.helpPageImageViewSecond.alpha = 0
                    weakself!.helpPageImageViewThird.alpha = 0
                    }, completion: { (finish) -> Void in
                        weakself!.helpPageImageViewSecond.image = UIImage.init(named: "helppage_message_second")
                        
                        weakself!.helpPageImageViewSecond.snp.remakeConstraints { (make) -> Void in
                            make.top.equalTo(self.snp.top).offset(64)
                            make.right.equalTo(weakself!.helpPageImageViewFirst.snp.left)
                            make.left.equalTo(self.snp.left).offset(20)
                        }
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            weakself!.helpPageImageViewFirst.alpha = 1
                            weakself!.helpPageImageViewSecond.alpha = 1
                            }, completion: { (finished) -> Void in
                                sender.isEnabled = true
                        })
                })
            }else if currentPage == 2{
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    weakself!.helpPageImageViewFirst.alpha = 0
                    weakself!.helpPageImageViewSecond.alpha = 0
                    weakself!.helpPageImageViewThird.alpha = 0
                    }, completion: { (finish) -> Void in
                        weakself!.helpPageImageViewSecond.image = UIImage.init(named: "helppage_message_third")
                        weakself!.helpPageImageViewSecond.snp.remakeConstraints { (make) -> Void in
                            make.top.equalTo(weakself!.snp.top).offset(64)
                            make.right.equalTo(weakself!.snp.right)
                            make.left.equalTo(weakself!.snp.left)
                        }
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            weakself!.helpPageImageViewSecond.alpha = 1
                            }, completion: { (finished) -> Void in
                                sender.isEnabled = true
                        })
                })
            }
            
        }else {
            //移除图片
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 0
                }, completion: { (finished) -> Void in
                    self.removeFromSuperview()
            })
        }
    }
}
