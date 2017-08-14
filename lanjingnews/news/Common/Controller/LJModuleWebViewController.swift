//
//  ModuleWebViewController.swift
//  news
//
//  Created by chunhui on 15/12/6.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class ModuleWebViewController: BaseViewController , UIWebViewDelegate {

    private var webView : UIWebView?
    
    private func initNavBar() {
    
    
    }
    
    private func backAction(_ sender : AnyObject!){
        if self.webView!.canGoBack {
            self.webView!.goBack()
        }else{
            self.closeAction(sender)
        }
    }
    
    private func closeAction(_ sender : AnyObject){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
