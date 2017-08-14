//
//  AboutLJViewController.swift
//  news
//
//  Created by 奥那 on 15/12/9.
//  Copyright © 2015年 lanjing. All rights reserved.
//

import UIKit

class AboutLJViewController: LJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于蓝鲸"

        layoutMySubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func layoutMySubviews(){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 95, width: 95, height: 182))
        imageView.centerX = self.view.centerX
        imageView.image = UIImage(named: "myInfo_logoin")
        imageView.contentMode = UIViewContentMode.ScaleToFill
        self.view.addSubview(imageView)
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
