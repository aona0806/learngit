//
//  AdviceViewController.swift
//  news
//
//  Created by 奥那 on 16/1/4.
//  Copyright © 2016年 lanjing. All rights reserved.
//

import UIKit

class AdviceViewController: LJBaseViewController, UITextViewDelegate {
    
    var contentView:UITextView!
    var placeholder:UILabel!
    var hud:MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        customNavigationItem()
        setupTextView()
    }
    
    func setupTextView(){
        contentView = UITextView.init(frame: CGRect(x: 16, y: 27, width: UIScreen.main.bounds.width - 32, height: 200))
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.font = UIFont.systemFont(ofSize: 17)
        contentView.textColor = UIColor.gray
        contentView.delegate = self
        self.view.addSubview(contentView)
        
        placeholder = UILabel.init(frame: CGRect(x: 6, y: 8, width: UIScreen.main.bounds.width - 32, height: 21))
        placeholder.text = "请输入您的意见，谢谢"
        placeholder.textColor = UIColor.rgba(217, green: 217, blue: 217, alpha: 1)
        contentView.addSubview(placeholder)
        
        hud = MBProgressHUD.init(view: self.view)
        self.view.addSubview(hud)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     自定义Navigation
     */
    func customNavigationItem(){
        self.title = "提点意见"
        let item  = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.done, target: self, action: #selector(AdviceViewController.commitAction))
        item.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.black], for: .normal)
        self.navigationItem.rightBarButtonItem = item
    }

    /**
     提交
     */
    func commitAction(){
        let message = self.contentView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if message.length() > 0 {
            
            hud.show(animated: true)
            TKRequestHandler.sharedInstance().commitAdvice(withUsername: AccountManager.sharedInstance.userName(), content: contentView.text) { [weak self](sessionDataTask, response, error) -> Void in
                
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.hud.mode = .text
                if error == nil {
                    let dic = response as! NSDictionary
                    let num:NSNumber = dic["errno"] as! NSNumber
                    if  num.intValue == 0{
                        strongSelf.contentView.text = ""
                        strongSelf.placeholder.isHidden = false
                        strongSelf.hud.hide(animated: true)
                        _ = strongSelf.showPopHud("提交成功", hideDelay: 0.5)
                        strongSelf.contentView.resignFirstResponder()
                        _ = strongSelf.navigationController?.popViewController(animated: true)
                    }
                }else{
                    strongSelf.hud.label.text = "提交失败";
                    strongSelf.hud.hide(animated: true, afterDelay: 0.5)
                }
            }
        }else {
            let hud  = MBProgressHUD.showAdded(to: self.view, animated:true)
            hud.mode = .text
            hud.label.text = "不能为空"
            hud.hide(animated: true, afterDelay: 0.5)
        }
    }
    
    //MARK: textView相关
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.length() > 0 {
            placeholder.isHidden = true
        }else{
            placeholder.isHidden = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
