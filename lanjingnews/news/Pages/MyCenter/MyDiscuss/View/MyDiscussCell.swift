//
//  MyDiscussCell.swift
//  news
//
//  Created by 奥那 on 15/12/11.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class MyDiscussCell: UITableViewCell {

    @IBOutlet weak var cellBackgrounpView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var forwardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var firstImageHeight: NSLayoutConstraint!

    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backgrounpLeading: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundTop: NSLayoutConstraint!
    
    @IBOutlet weak var contentLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
    
    @IBOutlet weak var forwardLabel: UILabel!
    var imageClick : ((MyDiscussCell , _ imageView : UIImageView?) -> ())? = nil

    var model : LJTweetDataContentModel?{
        didSet{
            updateMySubviews()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if #available(iOS 8.0, *) {
            self.layoutMargins = UIEdgeInsets.zero
//        } else {
//            // Fallback on earlier versions
//        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateMySubviews(){
        var Viewheight : CGFloat = 0.0
        var content = ""
        if model?.originTopic == nil{
            //自己发表
            publishByMyself()
            Viewheight = 0.0
            content = (model?.body)!
            
        }else{
            //转发
            publishByOthers()
            Viewheight = 20.0
            content = (model?.sname)! + " :  " + (model?.body)!
        }
        
        setupTime()
        setupImage()
        
        var imageHeight : CGFloat = 0
        if model!.img != nil {
            imageHeight += (model!.img?.count ?? 0) > 0 ? 65.0 : 0.0
        }

        contentLabel.attributedText = content.show( with: UIFont.systemFont(ofSize: 16), imageOffSet: UIOffsetMake(0, -4), lineSpace: 4.0,imageWidthRatio: CGFloat(1.5))
        
        let height = getHeightWithString(content)
        contentHeight.constant = height
        backgroundHeight.constant = height + Viewheight + imageHeight
    }
    
    func setupTime(){
        
        if model!.timestamp != nil {
        
            let time : NSString = model!.timestamp! as NSString
            let ctime = time.doubleValue
            let date = Date(timeIntervalSince1970: ctime)
            let timeStr = TKCommonTools.dateString(withFormat: TKDateFormatEnglishMedium2, date: date)
            let tempArr = timeStr?.components(separatedBy: "/")

            monthLabel?.text  = (tempArr?[0])! + "月"
            dayLabel?.text = tempArr?[1]
            
        }else{
            monthLabel?.text = nil
            dayLabel?.text = nil
        }
    }
    
    /**
     自己发表
     */
    func publishByMyself(){
        forwardLabel.isHidden = true
        forwardHeight.constant = 0
        backgrounpLeading.constant = -10
        backgroundTop.constant = 0
        contentLabelTop.constant = 0
        cellBackgrounpView.backgroundColor = UIColor.white

    }
    
    /**
     转发
     */
    func publishByOthers(){
        forwardLabel.isHidden = false
        forwardHeight.constant = 18
        backgrounpLeading.constant = 0
        backgroundTop.constant = 10
        contentLabelTop.constant = 10
        cellBackgrounpView.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)

    }
    
    func setupImage(){
        
        var imageViews = [firstImageView,secondImageView,thirdImageView]
        for iView in imageViews{
            iView?.isHidden = true
        }

        var imageCount = 0
        if model?.img != nil{
            imageCount = (model?.img?.count)!
        }
        var urls : Array<String> = []
        if imageCount > 0{
            firstImageHeight.constant = 60
            for index in 0  ..< imageCount {
                if let url = model!.img![index] as? String {
                    if(url.length()>0){
                        urls.append(url)
                        if(urls.count >= 3){
                            break
                        }
                    }
                }
            }
            imageCount = urls.count
        }else{
            firstImageHeight.constant = 0
        }
        
        if imageCount > 0{
            
            for index in 0  ..< imageCount  {
                let iView = imageViews[index]! as UIImageView

                iView.clipsToBounds = true
                 //set iview url
                let imageUrlString = urls[index] + "@!thumb0"
                let imgurl = Urlhelper.tryEncode(imageUrlString)
                iView.sd_setImage(with: imgurl)
                iView.isHidden = false
            }
        }
    }
  
    func getHeightWithString(_ text:String) -> CGFloat{
        let body = text.show( with: UIFont.systemFont(ofSize: 16), imageOffSet: UIOffsetMake(0, -4), lineSpace: 4.0,imageWidthRatio: CGFloat(1.5))
        let width = UIScreen.main.bounds.width - 101
        let contentRect = body!.size(withMaxWidth: width, font: UIFont.systemFont(ofSize: 16))
        let contentHeight: CGFloat = contentRect.height
        let height = contentHeight
        return height
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first!
        let point = touch.location(in: firstImageView.superview)
        
        var firstFrame = CGRect.zero
        var secondFrame = CGRect.zero
        var thirdFrame = CGRect.zero
        
        if firstImageHeight.constant != 0{
            firstFrame = firstImageView.frame
            
            if !secondImageView.isHidden {
                secondFrame = secondImageView.frame
            }
            if !thirdImageView.isHidden {
                thirdFrame = thirdImageView.frame
            }
            
            if self.imageClick != nil {
                var image : UIImageView? = nil
                if firstFrame.contains(point) {
                    image = self.firstImageView
                }else if secondFrame.contains(point ) {
                    image = self.secondImageView
                } else if thirdFrame.contains(point ) {
                    image = self.thirdImageView
                }
                
                if image != nil {
                    self.imageClick!(self,image )
                    return
                }
            }
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    
    class func CellHeightForModel(_ model : LJTweetDataContentModel) -> CGFloat {
        
        var imageHeight : CGFloat = 0
        if model.img != nil {
             imageHeight += ((model.img?.count ?? 0) > 0 ) ? 65.0 : 0.0
        }
        
        var bottomHeight : CGFloat = 0.0
        
        var topHeight : CGFloat = 0.0
        
        let cell = MyDiscussCell()
        
        var content = ""
        if model.originTopic == nil{
            topHeight += 18.0
            bottomHeight = 10.0
             content = (model.body)!
        }else{
            topHeight += 48.0
            bottomHeight = 30.0
            content = (model.sname)! + " :  " + (model.body)!
        }
        
        let contentHeight = cell.getHeightWithString(content)
        
        var height : CGFloat = topHeight + contentHeight + imageHeight + bottomHeight
        height = height < 70 ? 70 : height
        
        return height
    }
    
}
